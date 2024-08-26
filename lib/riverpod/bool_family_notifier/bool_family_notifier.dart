import 'package:flutter/material.dart' show Brightness, WidgetsBinding;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:red_owl/util/shared.dart' show SharedPreferenceService;
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;

part 'bool_family_notifier.g.dart';

@riverpod
class BoolFamilyNotifier extends _$BoolFamilyNotifier {
  @override
  bool build({required int id, required SharedPreferencesKeys sharedPrefsKey}) {
    switch (sharedPrefsKey) {
      case SharedPreferencesKeys.isDarkMode:
        bool? dataFromSharedPref =
            SharedPreferenceService().getBool(sharedPrefsKey.toString());

        if (dataFromSharedPref == null) {
          // https://stackoverflow.com/questions/56304215/how-to-check-if-dark-mode-is-enabled-on-ios-android-using-flutter
          var brightness =
              WidgetsBinding.instance.platformDispatcher.platformBrightness;
          return brightness == Brightness.dark;
        } else {
          // return Value from shared Pref
          return dataFromSharedPref;
        }
      default:
        return false;
    }
  }

  /// Update state & save boolean to Shared Preferences
  void updateBoolean(bool val, SharedPreferencesKeys sharedPrefKey) {
    // TODO: swap parameters
    // TODO: Save val to shared preferences
    SharedPreferenceService().setBool(sharedPrefKey.toString(), val);

    state = val;
  }
}
