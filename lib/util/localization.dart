import 'package:flutter/material.dart' show BuildContext;
import 'package:red_owl/l10n/app_localizations.dart';

extension Localization on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
