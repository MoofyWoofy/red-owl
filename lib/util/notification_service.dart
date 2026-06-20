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

  /// Requests the runtime notification permission (Android 13+). Returns
  /// whether permission is granted, defaulting to `true` on platforms that do
  /// not gate notifications behind a runtime prompt.
  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return true;
    return await android.requestNotificationsPermission() ?? false;
  }

  /// Schedules (or reschedules) the daily reminder at [hour]:[minute] with the
  /// given [title] and [body].
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    // Cancel any prior schedule so changing the time doesn't stack reminders.
    await _plugin.cancel(reminderId);

    await _plugin.zonedSchedule(
      reminderId,
      title,
      body,
      _nextInstanceOf(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      // Repeat every day at the same wall-clock time.
      matchDateTimeComponents: DateTimeComponents.time,
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
}
