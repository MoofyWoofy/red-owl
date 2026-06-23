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
    await _plugin.initialize(settings);
  }

  /// Resolves and sets the device's local time zone so scheduled times match
  /// the wall clock. Falls back to UTC if the platform lookup fails.
  Future<void> _configureLocalTimeZone() async {
    try {
      final dynamic result = await FlutterTimezone.getLocalTimezone();
      final name = result is String ? result : result.identifier as String;
      tz.setLocalLocation(tz.getLocation(name));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
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

  /// Schedules the next daily reminder at [hour]:[minute] with the given
  /// [title] and [body].
  ///
  /// This is a **one-shot** notification (not an OS-level daily repeat): the
  /// app re-arms it after each completed game and whenever the reminder is
  /// enabled or its time changed. This lets the reminder skip days the player
  /// has already played — an OS daily repeat cannot skip individual days.
  ///
  /// When [skipToday] is true the reminder is scheduled for tomorrow (used when
  /// today's game is already done); otherwise for the next occurrence of the
  /// time (today if still in the future, else tomorrow).
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    required String title,
    required String body,
    bool skipToday = false,
  }) async {
    // Cancel any prior schedule so changing the time doesn't stack reminders.
    await _plugin.cancel(reminderId);

    await _plugin.zonedSchedule(
      reminderId,
      title,
      body,
      skipToday ? _tomorrowAt(hour, minute) : _nextInstanceOf(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          // Monochrome status-bar icon (white owl silhouette) + full-color logo
          // shown as the large icon in the expanded notification.
          icon: 'ic_stat_reminder',
          largeIcon: DrawableResourceAndroidBitmap('ic_notification_large'),
        ),
      ),
      androidScheduleMode: await _scheduleMode(),
    );
  }

  /// Cancels the daily reminder, if any.
  Future<void> cancelReminder() => _plugin.cancel(reminderId);

  /// The next [tz.TZDateTime] matching [hour]:[minute] in local time (today if
  /// still in the future, otherwise tomorrow).
  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  /// Tomorrow's [tz.TZDateTime] at [hour]:[minute] in local time. Used to skip
  /// a reminder for the current day.
  tz.TZDateTime _tomorrowAt(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    return tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute)
        .add(const Duration(days: 1));
  }
}
