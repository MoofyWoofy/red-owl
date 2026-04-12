import 'package:flutter/material.dart' show BuildContext;
import 'package:red_owl/l10n/app_localizations.dart';

/// Extension on [BuildContext] that adds a convenient [l10n] getter.
///
/// Allows calling `context.l10n.someString` instead of the more verbose
/// `AppLocalizations.of(context)!.someString` throughout the widget tree.
extension Localization on BuildContext {
  /// Returns the [AppLocalizations] instance for the current locale.
  /// Asserts non-null — requires the app to have been wrapped with
  /// the [AppLocalizations.localizationsDelegates].
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
