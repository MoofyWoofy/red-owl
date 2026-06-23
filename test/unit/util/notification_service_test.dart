// Unit tests for NotificationService using a mocked plugin.
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:red_owl/util/shared.dart' show NotificationService;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MockPlugin extends Mock implements FlutterLocalNotificationsPlugin {}

class MockAndroidPlugin extends Mock
    implements AndroidFlutterLocalNotificationsPlugin {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('UTC'));
    registerFallbackValue(tz.TZDateTime.now(tz.local));
    registerFallbackValue(const NotificationDetails());
    registerFallbackValue(AndroidScheduleMode.inexactAllowWhileIdle);
    registerFallbackValue(DateTimeComponents.time);
  });

  late MockPlugin plugin;

  setUp(() {
    plugin = MockPlugin();
    NotificationService().pluginForTesting = plugin;
  });

  test('scheduleDailyReminder cancels the old schedule then schedules a new one',
      () async {
    when(() => plugin.cancel(any())).thenAnswer((_) async {});
    when(() => plugin.zonedSchedule(
          any(),
          any(),
          any(),
          any(),
          any(),
          androidScheduleMode: any(named: 'androidScheduleMode'),
          matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
        )).thenAnswer((_) async {});

    await NotificationService().scheduleDailyReminder(
      hour: 20,
      minute: 0,
      title: 'Red Owl',
      body: 'Play!',
    );

    verify(() => plugin.cancel(NotificationService.reminderId)).called(1);
    verify(() => plugin.zonedSchedule(
          NotificationService.reminderId,
          'Red Owl',
          'Play!',
          any(),
          any(),
          androidScheduleMode: any(named: 'androidScheduleMode'),
          matchDateTimeComponents: DateTimeComponents.time,
        )).called(1);
  });

  test('cancelReminder cancels the reminder id', () async {
    when(() => plugin.cancel(any())).thenAnswer((_) async {});
    await NotificationService().cancelReminder();
    verify(() => plugin.cancel(NotificationService.reminderId)).called(1);
  });

  test('requestPermission returns true when there is no Android implementation',
      () async {
    // The mock returns null for resolvePlatformSpecificImplementation, the
    // non-Android path, which grants by default.
    expect(await NotificationService().requestPermission(), isTrue);
  });

  // Stubs zonedSchedule/cancel and wires a mock Android implementation that
  // reports the given exact-alarm permission state.
  MockAndroidPlugin stubAndroid({required bool canScheduleExact}) {
    final android = MockAndroidPlugin();
    when(() => plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()).thenReturn(android);
    when(() => android.canScheduleExactNotifications())
        .thenAnswer((_) async => canScheduleExact);
    when(() => plugin.cancel(any())).thenAnswer((_) async {});
    when(() => plugin.zonedSchedule(
          any(),
          any(),
          any(),
          any(),
          any(),
          androidScheduleMode: any(named: 'androidScheduleMode'),
          matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
        )).thenAnswer((_) async {});
    return android;
  }

  AndroidScheduleMode capturedScheduleMode() {
    return verify(() => plugin.zonedSchedule(
          any(),
          any(),
          any(),
          any(),
          any(),
          androidScheduleMode: captureAny(named: 'androidScheduleMode'),
          matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
        )).captured.single as AndroidScheduleMode;
  }

  test('schedules with exact mode when exact alarms are permitted', () async {
    stubAndroid(canScheduleExact: true);

    await NotificationService().scheduleDailyReminder(
        hour: 9, minute: 20, title: 'Red Owl', body: 'Play!');

    expect(capturedScheduleMode(), AndroidScheduleMode.exactAllowWhileIdle);
  });

  test('falls back to inexact mode when exact alarms are not permitted',
      () async {
    stubAndroid(canScheduleExact: false);

    await NotificationService().scheduleDailyReminder(
        hour: 9, minute: 20, title: 'Red Owl', body: 'Play!');

    expect(capturedScheduleMode(), AndroidScheduleMode.inexactAllowWhileIdle);
  });

  test('requestExactAlarmPermission requests access when not yet granted',
      () async {
    final android = stubAndroid(canScheduleExact: false);
    when(() => android.requestExactAlarmsPermission())
        .thenAnswer((_) async => true);

    await NotificationService().requestExactAlarmPermission();

    verify(() => android.requestExactAlarmsPermission()).called(1);
  });

  test('requestExactAlarmPermission does nothing when already granted',
      () async {
    final android = stubAndroid(canScheduleExact: true);

    await NotificationService().requestExactAlarmPermission();

    verifyNever(() => android.requestExactAlarmsPermission());
  });
}
