import 'package:flutter/material.dart' show Brightness, WidgetsBinding;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:red_owl/util/shared.dart' show SharedPreferenceService;
import 'package:red_owl/config/shared.dart'
    show SharedPreferencesKeys, BoolFamilyProviderIDs;

part 'bool_family_notifier.g.dart';

/// Riverpod family notifier for boolean settings backed by SharedPreferences.
///
/// A single notifier class handles any number of boolean toggles by taking
/// [id] (a stable [BoolFamilyProviderIDs] value) and [sharedPrefsKey] as
/// family parameters. This avoids duplicating notifier code for every toggle.
///
/// On first access the [build] method reads the persisted value and returns
/// a sensible default if none is stored. [updateBoolean] persists the new
/// value and updates the Riverpod state so the UI rebuilds reactively.
@riverpod
class BoolFamilyNotifier extends _$BoolFamilyNotifier {
  /// Reads the initial boolean value from SharedPreferences.
  ///
  /// Every key reads back its persisted value so the toggle survives restarts.
  /// Key-specific defaults (used only when nothing is stored yet):
  /// - [SharedPreferencesKeys.isDarkMode]: falls back to the system brightness.
  /// - Any other key (hard mode, color-blind mode, reminder, custom list):
  ///   defaults to `false`.
  @override
  bool build({
    required BoolFamilyProviderIDs id,
    required SharedPreferencesKeys sharedPrefsKey,
  }) {
    final bool? dataFromSharedPref =
        SharedPreferenceService().getBool(sharedPrefsKey);

    if (dataFromSharedPref == null &&
        sharedPrefsKey == SharedPreferencesKeys.isDarkMode) {
      // No saved dark-mode preference — mirror the device's current theme.
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }

    // Return the explicitly saved value, or false when nothing is stored.
    return dataFromSharedPref ?? false;
  }

  /// Persists [val] to SharedPreferences under [sharedPrefKey] and
  /// synchronously updates the Riverpod state so dependent widgets rebuild.
  void updateBoolean(SharedPreferencesKeys sharedPrefKey, bool val) {
    SharedPreferenceService().setBool(sharedPrefKey, val);
    state = val;
  }
}
