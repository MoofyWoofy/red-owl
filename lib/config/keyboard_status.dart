import 'package:red_owl/config/letter_status.dart';

/// Default keyboard status map for a QWERTY layout.
///
/// Each key maps to its current [LetterStatus] (initial, green, yellow, or
/// notInWord). The order matches the three physical keyboard rows so that
/// [KeyboardRow] can slice the map by index range to render each row.
///
/// This map is mutable so it can be reset at the start of each game via
/// `updateAll` in [_WordlePageState.initState].
Map<String, LetterStatus> keyboardStatus = {
  // ── Row 1 ──
  'Q': LetterStatus.initial,
  'W': LetterStatus.initial,
  'E': LetterStatus.initial,
  'R': LetterStatus.initial,
  'T': LetterStatus.initial,
  'Y': LetterStatus.initial,
  'U': LetterStatus.initial,
  'I': LetterStatus.initial,
  'O': LetterStatus.initial,
  'P': LetterStatus.initial,
  // ── Row 2 ──
  'A': LetterStatus.initial,
  'S': LetterStatus.initial,
  'D': LetterStatus.initial,
  'F': LetterStatus.initial,
  'G': LetterStatus.initial,
  'H': LetterStatus.initial,
  'J': LetterStatus.initial,
  'K': LetterStatus.initial,
  'L': LetterStatus.initial,
  // ── Row 3 (with ENTER and DELETE action keys) ──
  'ENTER': LetterStatus.initial,
  'Z': LetterStatus.initial,
  'X': LetterStatus.initial,
  'C': LetterStatus.initial,
  'V': LetterStatus.initial,
  'B': LetterStatus.initial,
  'N': LetterStatus.initial,
  'M': LetterStatus.initial,
  'DELETE': LetterStatus.initial,
};
