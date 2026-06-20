// Unit tests for HintNotifier (the once-per-day hint availability flag).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/riverpod/shared.dart' show hintProvider;
import 'package:red_owl/util/shared.dart'
    show SharedPreferenceService, dateToString;

import '../../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ProviderContainer makeContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  group('HintNotifier', () {
    test('is available when no hint has been used', () async {
      setSharedPreferencesMock();
      await SharedPreferenceService().init();
      expect(makeContainer().read(hintProvider), isTrue);
    });

    test('is unavailable when a hint was already used today', () async {
      setSharedPreferencesMock({
        SharedPreferencesKeys.hintUsedDate.name:
            dateToString(DateTime.now()),
      });
      await SharedPreferenceService().init();
      expect(makeContainer().read(hintProvider), isFalse);
    });

    test('is available again after the day rolls over', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      setSharedPreferencesMock({
        SharedPreferencesKeys.hintUsedDate.name: dateToString(yesterday),
      });
      await SharedPreferenceService().init();
      expect(makeContainer().read(hintProvider), isTrue);
    });

    test('useHint consumes the hint and persists today', () async {
      setSharedPreferencesMock();
      await SharedPreferenceService().init();
      final container = makeContainer();

      container.read(hintProvider.notifier).useHint();
      expect(container.read(hintProvider), isFalse);
      expect(
        SharedPreferenceService()
            .getString(SharedPreferencesKeys.hintUsedDate),
        dateToString(DateTime.now()),
      );
    });
  });
}
