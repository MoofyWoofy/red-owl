// Widget tests for the ReminderSetting (daily reminder toggle + time).
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/routes/settings/widgets/shared.dart'
    show ReminderSetting;
import 'package:red_owl/util/shared.dart'
    show NotificationService, SharedPreferenceService;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../helpers/test_helpers.dart';

class MockPlugin extends Mock implements FlutterLocalNotificationsPlugin {}

void main() {
  late MockPlugin plugin;

  setUpAll(() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('UTC'));
    registerFallbackValue(tz.TZDateTime.now(tz.local));
    registerFallbackValue(const NotificationDetails());
    registerFallbackValue(AndroidScheduleMode.inexactAllowWhileIdle);
    registerFallbackValue(DateTimeComponents.time);
  });

  setUp(() async {
    setSharedPreferencesMock();
    await SharedPreferenceService().init();
    plugin = MockPlugin();
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
    NotificationService().pluginForTesting = plugin;
  });

  testWidgets('renders the toggle, off by default with no time row',
      (tester) async {
    await tester.pumpWidget(makeTestApp(child: const ReminderSetting()));
    await tester.pumpAndSettle();

    expect(find.text('Daily reminder'), findsOneWidget);
    expect(find.byType(SwitchListTile), findsOneWidget);
    // Time row only appears once enabled.
    expect(find.text('Reminder time'), findsNothing);
  });

  testWidgets('enabling schedules the reminder and reveals the time row',
      (tester) async {
    await tester.pumpWidget(makeTestApp(child: const ReminderSetting()));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    // Scheduled and persisted.
    verify(() => plugin.zonedSchedule(
          any(),
          any(),
          any(),
          any(),
          any(),
          androidScheduleMode: any(named: 'androidScheduleMode'),
          matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
        )).called(1);
    expect(
      SharedPreferenceService().getBool(SharedPreferencesKeys.reminderEnabled),
      isTrue,
    );
    expect(find.text('Reminder time'), findsOneWidget);
  });
}
