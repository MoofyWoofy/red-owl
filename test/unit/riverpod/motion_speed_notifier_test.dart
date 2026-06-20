// Unit tests for MotionSpeedNotifier (the global animation-speed preference).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/riverpod/shared.dart'
    show
        motionSpeedProvider,
        motionSpeedNormal,
        motionSpeedReduced,
        motionDilationOf;
import 'package:red_owl/util/shared.dart' show SharedPreferenceService;

import '../../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ProviderContainer makeContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  group('MotionSpeedNotifier', () {
    test('defaults to "normal" when no preference is stored', () async {
      setSharedPreferencesMock();
      await SharedPreferenceService().init();
      final container = makeContainer();
      expect(container.read(motionSpeedProvider), motionSpeedNormal);
    });

    test('reads a stored speed code on build', () async {
      setSharedPreferencesMock({
        SharedPreferencesKeys.motionSpeed.name: 'fast',
      });
      await SharedPreferenceService().init();
      final container = makeContainer();
      expect(container.read(motionSpeedProvider), 'fast');
    });

    test('setSpeed updates state and persists the code', () async {
      setSharedPreferencesMock();
      await SharedPreferenceService().init();
      final container = makeContainer();

      container.read(motionSpeedProvider.notifier).setSpeed('slow');
      expect(container.read(motionSpeedProvider), 'slow');
      expect(
        SharedPreferenceService().getString(SharedPreferencesKeys.motionSpeed),
        'slow',
      );
    });
  });

  group('motionDilationOf', () {
    test('maps known codes to their timeDilation factors', () {
      expect(motionDilationOf(motionSpeedReduced), 0.02);
      expect(motionDilationOf('fast'), 0.5);
      expect(motionDilationOf('normal'), 1.0);
      expect(motionDilationOf('slow'), 1.8);
    });

    test('falls back to 1.0 for an unknown code', () {
      expect(motionDilationOf('bogus'), 1.0);
    });
  });
}
