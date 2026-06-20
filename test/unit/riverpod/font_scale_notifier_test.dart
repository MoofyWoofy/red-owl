// Unit tests for FontScaleNotifier (the global text-size preference).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/riverpod/shared.dart'
    show fontScaleProvider, fontScaleNormal, fontScaleValueOf;
import 'package:red_owl/util/shared.dart' show SharedPreferenceService;

import '../../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ProviderContainer makeContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  group('FontScaleNotifier', () {
    test('defaults to "normal" when no preference is stored', () async {
      setSharedPreferencesMock();
      await SharedPreferenceService().init();
      final container = makeContainer();
      expect(container.read(fontScaleProvider), fontScaleNormal);
    });

    test('reads a stored scale code on build', () async {
      setSharedPreferencesMock({
        SharedPreferencesKeys.fontScale.name: 'large',
      });
      await SharedPreferenceService().init();
      final container = makeContainer();
      expect(container.read(fontScaleProvider), 'large');
    });

    test('setScale updates state and persists the code', () async {
      setSharedPreferencesMock();
      await SharedPreferenceService().init();
      final container = makeContainer();

      container.read(fontScaleProvider.notifier).setScale('xlarge');
      expect(container.read(fontScaleProvider), 'xlarge');
      expect(
        SharedPreferenceService().getString(SharedPreferencesKeys.fontScale),
        'xlarge',
      );
    });
  });

  group('fontScaleValueOf', () {
    test('maps known codes to their multipliers', () {
      expect(fontScaleValueOf('small'), 0.85);
      expect(fontScaleValueOf('normal'), 1.0);
      expect(fontScaleValueOf('large'), 1.15);
      expect(fontScaleValueOf('xlarge'), 1.3);
    });

    test('falls back to 1.0 for an unknown code', () {
      expect(fontScaleValueOf('bogus'), 1.0);
    });
  });
}
