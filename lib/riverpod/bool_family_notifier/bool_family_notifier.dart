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
  /// Key-specific defaults:
  /// - [SharedPreferencesKeys.isDarkMode]: falls back to the system brightness
  ///   when no user preference has been saved yet.
  /// - [SharedPreferencesKeys.useCustomList]: defaults to `false` (standard
  ///   word list) when not set.
  /// - Any other key: defaults to `false`.
  @override
  bool build({
    required BoolFamilyProviderIDs id,
    required SharedPreferencesKeys sharedPrefsKey,
  }) {
    switch (sharedPrefsKey) {
      case SharedPreferencesKeys.isDarkMode:
        bool? dataFromSharedPref =
            SharedPreferenceService().getBool(sharedPrefsKey);

        if (dataFromSharedPref == null) {
          // No saved preference — mirror the device's current theme setting.
          var brightness =
              WidgetsBinding.instance.platformDispatcher.platformBrightness;
          return brightness == Brightness.dark;
        } else {
          // Return the explicitly saved user preference.
          return dataFromSharedPref;
        }

      case SharedPreferencesKeys.useCustomList:
        bool? dataFromSharedPref =
            SharedPreferenceService().getBool(sharedPrefsKey);
        // Default to false (use standard list) when not previously set.
        return dataFromSharedPref ?? false;

      default:
        return false;
    }
  }

  /// Persists [val] to SharedPreferences under [sharedPrefKey] and
  /// synchronously updates the Riverpod state so dependent widgets rebuild.
  void updateBoolean(SharedPreferencesKeys sharedPrefKey, bool val) {
    SharedPreferenceService().setBool(sharedPrefKey, val);
    state = val;
  }
}
