// Unit tests for LocaleNotifier (the UI language override).
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/riverpod/shared.dart'
    show localeProvider, systemLocaleCode;
import 'package:red_owl/util/shared.dart' show SharedPreferenceService;

import '../../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ProviderContainer makeContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  group('LocaleNotifier', () {
    test('defaults to null (follow system) when no preference is stored',
        () async {
      setSharedPreferencesMock();
      await SharedPreferenceService().init();
      final container = makeContainer();
      expect(container.read(localeProvider), isNull);
    });

    test('reads a stored locale code on build', () async {
      setSharedPreferencesMock({
        SharedPreferencesKeys.localeCode.name: 'nl',
      });
      await SharedPreferenceService().init();
      final container = makeContainer();
      expect(container.read(localeProvider), const Locale('nl'));
    });

    test('setLocale updates state and persists the code', () async {
      setSharedPreferencesMock();
      await SharedPreferenceService().init();
      final container = makeContainer();

      container.read(localeProvider.notifier).setLocale('nl');
      expect(container.read(localeProvider), const Locale('nl'));
      expect(
        SharedPreferenceService().getString(SharedPreferencesKeys.localeCode),
        'nl',
      );
    });

    test('setLocale(system) clears the override back to null', () async {
      setSharedPreferencesMock({
        SharedPreferencesKeys.localeCode.name: 'nl',
      });
      await SharedPreferenceService().init();
      final container = makeContainer();
      expect(container.read(localeProvider), const Locale('nl'));

      container.read(localeProvider.notifier).setLocale(systemLocaleCode);
      expect(container.read(localeProvider), isNull);
    });
  });
}
