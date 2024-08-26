import 'package:flutter/material.dart' show Brightness, WidgetsBinding;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:red_owl/util/shared.dart' show SharedPreferenceService;
import 'package:red_owl/config/shared.dart'
    show SharedPreferencesKeys, BoolFamilyProviderIDs;

part 'bool_family_notifier.g.dart';

@riverpod
class BoolFamilyNotifier extends _$BoolFamilyNotifier {
  @override
  bool build({
    required BoolFamilyProviderIDs id,
    required SharedPreferencesKeys sharedPrefsKey,
  }) {
    switch (sharedPrefsKey) {
      case SharedPreferencesKeys.isDarkMode:
        bool? dataFromSharedPref =
            SharedPreferenceService().getBool(sharedPrefsKey.toString());

        if (dataFromSharedPref == null) {
          // If no data is in shared Preferences, use system brightness instead.
          var brightness =
              WidgetsBinding.instance.platformDispatcher.platformBrightness;
          return brightness == Brightness.dark;
        } else {
          // if data exists in shared Preferences, return value.
          return dataFromSharedPref;
        }
      default:
        // Default value if not specified.
        return false;
    }
  }

  /// Update state & save boolean to Shared Preferences.
  void updateBoolean(SharedPreferencesKeys sharedPrefKey, bool val) {
    SharedPreferenceService().setBool(sharedPrefKey.toString(), val);
    state = val;
  }
}
