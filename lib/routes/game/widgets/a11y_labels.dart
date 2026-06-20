import 'package:flutter/widgets.dart';
import 'package:red_owl/config/shared.dart' show LetterStatus;
import 'package:red_owl/util/shared.dart' show Localization;

/// Builds a screen-reader label for a [letter] given its [status].
///
/// Used by both the grid [Tile]s and the on-screen keyboard [Letter]s so the
/// spoken description ("A, correct" / "A, absent") stays consistent. When the
/// letter has not been evaluated yet ([LetterStatus.initial] or `null`), the
/// bare letter is returned so the reader just announces the character.
String letterStatusLabel(
  BuildContext context,
  String letter,
  LetterStatus? status,
) {
  final l10n = context.l10n;
  final String? statusWord;
  switch (status) {
    case LetterStatus.green:
      statusWord = l10n.a11yStatusCorrect;
    case LetterStatus.yellow:
      statusWord = l10n.a11yStatusPresent;
    case LetterStatus.notInWord:
      statusWord = l10n.a11yStatusAbsent;
    case LetterStatus.initial:
    case null:
      statusWord = null;
  }
  if (statusWord == null) return letter;
  return l10n.a11yLetterWithStatus(letter, statusWord);
}
