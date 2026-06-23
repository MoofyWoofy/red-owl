// Unit tests for ReminderTimeNotifier (the daily-reminder time preference).
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/riverpod/shared.dart'
    show reminderTimeProvider, defaultReminderTime, parseReminderTime;
import 'package:red_owl/util/shared.dart' show SharedPreferenceService;

import '../../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ProviderContainer makeContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  group('ReminderTimeNotifier', () {
    test('defaults to 8 PM when nothing is stored', () async {
      setSharedPreferencesMock();
      await SharedPreferenceService().init();
      final container = makeContainer();

      expect(container.read(reminderTimeProvider), defaultReminderTime);
    });

    test('reads a stored HH:mm value on build', () async {
      setSharedPreferencesMock({
        SharedPreferencesKeys.reminderTime.name: '09:20',
      });
      await SharedPreferenceService().init();
      final container = makeContainer();

      expect(
        container.read(reminderTimeProvider),
        const TimeOfDay(hour: 9, minute: 20),
      );
    });

    test('falls back to the default for a malformed stored value', () async {
      setSharedPreferencesMock({
        SharedPreferencesKeys.reminderTime.name: 'not-a-time',
      });
      await SharedPreferenceService().init();
      final container = makeContainer();

      expect(container.read(reminderTimeProvider), defaultReminderTime);
    });

    test('setTime updates state and persists a zero-padded HH:mm', () async {
      setSharedPreferencesMock();
      await SharedPreferenceService().init();
      final container = makeContainer();

      container
          .read(reminderTimeProvider.notifier)
          .setTime(const TimeOfDay(hour: 9, minute: 20));

      expect(
        container.read(reminderTimeProvider),
        const TimeOfDay(hour: 9, minute: 20),
      );
      expect(
        SharedPreferenceService().getString(SharedPreferencesKeys.reminderTime),
        '09:20',
      );

      // A fresh build (simulating a restart) reads the persisted value back.
      final restarted = makeContainer();
      expect(
        restarted.read(reminderTimeProvider),
        const TimeOfDay(hour: 9, minute: 20),
      );
    });

    test('setTime notifies listeners when the time changes', () async {
      setSharedPreferencesMock();
      await SharedPreferenceService().init();
      final container = makeContainer();

      final seen = <TimeOfDay>[];
      container.listen(
        reminderTimeProvider,
        (_, next) => seen.add(next),
        fireImmediately: false,
      );

      container
          .read(reminderTimeProvider.notifier)
          .setTime(const TimeOfDay(hour: 9, minute: 20));

      expect(seen, [const TimeOfDay(hour: 9, minute: 20)]);
    });
  });

  group('parseReminderTime', () {
    test('parses a valid HH:mm string', () {
      expect(parseReminderTime('07:05'), const TimeOfDay(hour: 7, minute: 5));
    });

    test('returns null for null, empty, or malformed input', () {
      expect(parseReminderTime(null), isNull);
      expect(parseReminderTime(''), isNull);
      expect(parseReminderTime('20'), isNull);
      expect(parseReminderTime('aa:bb'), isNull);
    });
  });
}
