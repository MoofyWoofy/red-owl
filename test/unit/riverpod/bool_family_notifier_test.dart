// Unit tests for BoolFamilyNotifier (the generic boolean-settings notifier).
//
// Regression coverage for the bug where toggles other than dark mode and the
// custom-list switch (hard mode, color-blind mode, daily reminder) wrote their
// value to SharedPreferences but always read back `false` on the next build, so
// the setting appeared not to save across restarts.
import 'package:flutter/material.dart' show Brightness;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/config/shared.dart'
    show SharedPreferencesKeys, BoolFamilyProviderIDs;
import 'package:red_owl/riverpod/shared.dart' show boolFamilyProvider;
import 'package:red_owl/util/shared.dart' show SharedPreferenceService;

import '../../helpers/test_helpers.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  ProviderContainer makeContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  // The (provider id, prefs key) pairs for every boolean setting that defaults
  // to false and must round-trip through SharedPreferences.
  final togglePairs = <(BoolFamilyProviderIDs, SharedPreferencesKeys)>[
    (BoolFamilyProviderIDs.isHardMode, SharedPreferencesKeys.isHardMode),
    (
      BoolFamilyProviderIDs.isColorBlindMode,
      SharedPreferencesKeys.isColorBlindMode
    ),
    (
      BoolFamilyProviderIDs.reminderEnabled,
      SharedPreferencesKeys.reminderEnabled
    ),
    (BoolFamilyProviderIDs.useCustomList, SharedPreferencesKeys.useCustomList),
  ];

  group('BoolFamilyNotifier', () {
    for (final (id, key) in togglePairs) {
      test('${key.name} defaults to false when nothing is stored', () async {
        setSharedPreferencesMock();
        await SharedPreferenceService().init();
        final container = makeContainer();

        expect(
          container.read(boolFamilyProvider(id: id, sharedPrefsKey: key)),
          isFalse,
        );
      });

      test('${key.name} reads back a stored true value on build', () async {
        setSharedPreferencesMock({key.name: true});
        await SharedPreferenceService().init();
        final container = makeContainer();

        expect(
          container.read(boolFamilyProvider(id: id, sharedPrefsKey: key)),
          isTrue,
        );
      });

      test('${key.name} persists an updated value to SharedPreferences',
          () async {
        setSharedPreferencesMock();
        await SharedPreferenceService().init();
        final container = makeContainer();

        container
            .read(boolFamilyProvider(id: id, sharedPrefsKey: key).notifier)
            .updateBoolean(key, true);

        // In-memory state updates immediately ...
        expect(
          container.read(boolFamilyProvider(id: id, sharedPrefsKey: key)),
          isTrue,
        );
        // ... and the value is written through to SharedPreferences, so a fresh
        // build (simulating an app restart) reads it back.
        expect(SharedPreferenceService().getBool(key), isTrue);

        final restarted = makeContainer();
        expect(
          restarted.read(boolFamilyProvider(id: id, sharedPrefsKey: key)),
          isTrue,
        );
      });
    }

    group('isDarkMode', () {
      const id = BoolFamilyProviderIDs.isDarkMode;
      const key = SharedPreferencesKeys.isDarkMode;

      test('falls back to the system brightness when unset', () async {
        binding.platformDispatcher.platformBrightnessTestValue =
            Brightness.dark;
        addTearDown(binding.platformDispatcher.clearPlatformBrightnessTestValue);

        setSharedPreferencesMock();
        await SharedPreferenceService().init();
        final container = makeContainer();

        expect(
          container.read(boolFamilyProvider(id: id, sharedPrefsKey: key)),
          isTrue,
        );
      });

      test('honours a stored value over the system brightness', () async {
        binding.platformDispatcher.platformBrightnessTestValue =
            Brightness.dark;
        addTearDown(binding.platformDispatcher.clearPlatformBrightnessTestValue);

        setSharedPreferencesMock({key.name: false});
        await SharedPreferenceService().init();
        final container = makeContainer();

        expect(
          container.read(boolFamilyProvider(id: id, sharedPrefsKey: key)),
          isFalse,
        );
      });
    });
  });
}
