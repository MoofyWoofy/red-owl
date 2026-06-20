import 'package:flutter/widgets.dart' show Locale;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/util/shared.dart' show SharedPreferenceService;

part 'locale_notifier.g.dart';

/// Sentinel locale code meaning "follow the device language".
const String systemLocaleCode = 'system';

/// Riverpod notifier holding the app's UI [Locale] override.
///
/// A `null` value means "use the system locale" (no explicit override), which
/// lets [MaterialApp] fall back to the device language. A non-null [Locale]
/// forces the UI into that language regardless of the device setting.
///
/// The choice is persisted under [SharedPreferencesKeys.localeCode] so it
/// survives restarts. `App` (in `main.dart`) watches this provider and passes
/// the value to `MaterialApp.locale`.
@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale? build() {
    final code =
        SharedPreferenceService().getString(SharedPreferencesKeys.localeCode);
    if (code == null || code.isEmpty || code == systemLocaleCode) {
      return null;
    }
    return Locale(code);
  }

  /// Persists [code] and updates the active locale.
  ///
  /// Pass [systemLocaleCode] (or `'system'`) to clear the override and follow
  /// the device language; pass a supported language code (e.g. `'en'`, `'nl'`)
  /// to force that language.
  void setLocale(String code) {
    SharedPreferenceService()
        .setString(SharedPreferencesKeys.localeCode, code);
    state = code == systemLocaleCode ? null : Locale(code);
  }
}
