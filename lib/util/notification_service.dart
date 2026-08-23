import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Singleton wrapper around [FlutterLocalNotificationsPlugin] for the opt-in
/// daily reminder.
///
/// The reminder is a single repeating local notification (off by default). The
/// underlying plugin is injectable via [setPluginForTesting] so the scheduling
/// logic can be unit-tested without the platform channel.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  /// Notification + channel identifiers for the daily reminder.
  static const int reminderId = 1001;
  static const String _channelId = 'daily_reminder';
  static const String _channelName = 'Daily reminder';

  FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  /// Replaces the underlying plugin (used by tests with a mock).
  // ignore: avoid_setters_without_getters
  set pluginForTesting(FlutterLocalNotificationsPlugin plugin) =>
      _plugin = plugin;

  /// Initialises the plugin and the local time zone database. Safe to call
  /// more than once.
  Future<void> init() async {
    tz.initializeTimeZones();
    await _configureLocalTimeZone();

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _plugin.initialize(settings: settings);
  }

  /// Resolves and sets the device's local time zone so scheduled times match
  /// the wall clock. Falls back to UTC if the platform lookup fails.
  Future<void> _configureLocalTimeZone() async {
    try {
      final dynamic result = await FlutterTimezone.getLocalTimezone();
      final name = result is String ? result : result.identifier as String;
      tz.setLocalLocation(tz.getLocation(name));
    } catch (_) {
      // `tz.UTC` rather than `getLocation('UTC')`: timezone 0.11 renamed the
      // database entry to `Etc/UTC`, so looking it up by the old name throws.
      // The getter is a built-in Location and does not depend on the name.
      tz.setLocalLocation(tz.UTC);
    }
  }

  /// The Android-specific plugin implementation, or `null` on other platforms.
  AndroidFlutterLocalNotificationsPlugin? get _androidPlugin =>
      _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  /// Requests the runtime notification permission (Android 13+). Returns
  /// whether permission is granted, defaulting to `true` on platforms that do
  /// not gate notifications behind a runtime prompt.
  Future<bool> requestPermission() async {
    final android = _androidPlugin;
    if (android == null) return true;
    return await android.requestNotificationsPermission() ?? false;
  }

  /// Best-effort request for the "alarms & reminders" (exact alarm) permission
  /// so the daily reminder can fire to the exact minute.
  ///
  /// Does nothing if already granted or on platforms without the concept. When
  /// not granted, this opens the system settings screen (Android 12+); the
  /// reminder still works via inexact scheduling if the user declines, so the
  /// caller does not need to react to the outcome.
  Future<void> requestExactAlarmPermission() async {
    final android = _androidPlugin;
    if (android == null) return;
    final canExact = await android.canScheduleExactNotifications() ?? false;
    if (!canExact) {
      await android.requestExactAlarmsPermission();
    }
  }

  /// Picks the schedule mode based on whether exact alarms are permitted:
  /// exact (to-the-minute) when allowed, otherwise the inexact variant so the
  /// reminder still works without the special permission.
  Future<AndroidScheduleMode> _scheduleMode() async {
    final canExact =
        await _androidPlugin?.canScheduleExactNotifications() ?? false;
    return canExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
  }

  /// Schedules the daily reminder at [hour]:[minute] with the given [title]
  /// and [body].
  ///
  /// This is an **OS-level daily repeat** (`matchDateTimeComponents: time`): the
  /// plugin re-fires it at the next occurrence of the time every day, so the
  /// reminder keeps nudging even if the app is never reopened. It fires every
  /// day regardless of whether the player has already played that day.
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    // Cancel any prior schedule so changing the time doesn't stack reminders.
    await _plugin.cancel(id: reminderId);

    await _plugin.zonedSchedule(
      id: reminderId,
      title: title,
      body: body,
      scheduledDate: _nextInstanceOf(hour, minute),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          // Monochrome status-bar icon (white owl silhouette).
          icon: 'ic_stat_reminder',
        ),
      ),
      androidScheduleMode: await _scheduleMode(),
      // Repeat daily at the same wall-clock time.
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Cancels the daily reminder, if any.
  Future<void> cancelReminder() => _plugin.cancel(id: reminderId);

  /// Brings the OS schedule in line with the given reminder preferences,
  /// returning whether a reminder is actually scheduled afterwards.
  ///
  /// The toggle and the time are stored by the app, but the schedule itself
  /// lives with the platform. Anything that changes those preferences behind
  /// the settings UI's back -- restoring a backup -- leaves the two
  /// disagreeing, with the switch reading on while nothing is scheduled on this
  /// device, or reading off while an old reminder keeps firing.
  ///
  /// **Never throws**, so a caller mid-way through a larger operation cannot
  /// have that operation fail on a notification problem. A `false` return means
  /// no reminder is scheduled -- the permission was refused, or the platform
  /// rejected the schedule -- and the caller should correct the stored toggle
  /// so it does not claim a reminder that does not exist.
  Future<bool> applyReminder({
    required bool enabled,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    try {
      if (!enabled) {
        await cancelReminder();
        return false;
      }
      // Preferences cannot carry an OS permission grant, so this device may
      // still have to ask.
      if (!await requestPermission()) return false;
      await requestExactAlarmPermission();
      await scheduleDailyReminder(
        hour: hour,
        minute: minute,
        title: title,
        body: body,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// The next [tz.TZDateTime] matching [hour]:[minute] in local time (today if
  /// still in the future, otherwise tomorrow).
  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (!scheduled.isAfter(now)) {
      // Rebuild on the next calendar day rather than adding 24 hours. Adding a
      // Duration is absolute, so across a DST transition it would land an hour
      // off the requested wall-clock time. The constructor normalises a day
      // past the end of the month.
      scheduled = tz.TZDateTime(
          tz.local, now.year, now.month, now.day + 1, hour, minute);
    }
    return scheduled;
  }
}
