import 'package:red_owl/config/letter_status.dart';

/// The on-screen keyboard layout, in render order.
///
/// [KeyboardRow] slices this list by index to draw the three physical rows, so
/// the order here is the source of truth for the layout:
/// - Row 1 (Q–P), Row 2 (A–L), Row 3 (ENTER, Z–M, DELETE).
///
/// It is intentionally separate from game state: key *colours* live in the grid
/// notifier's `keyboardStatus` map; this list only says which keys exist and in
/// what order.
const List<String> keyboardLayout = [
  'Q',
  'W',
  'E',
  'R',
  'T',
  'Y',
  'U',
  'I',
  'O',
  'P',
  'A',
  'S',
  'D',
  'F',
  'G',
  'H',
  'J',
  'K',
  'L',
  'ENTER',
  'Z',
  'X',
  'C',
  'V',
  'B',
  'N',
  'M',
  'DELETE',
];

/// A fresh, all-[LetterStatus.initial] keyboard status map.
///
/// Returns a **new** map on every call, and every board must start from one.
/// This used to be a single mutable top-level map handed straight to the grid
/// notifier as its initial state and then mutated in place (`updateAll`) when
/// the board mounted — which changed notifier state without going through
/// Riverpod (no rebuild) and shared one object between the daily and practice
/// provider scopes.
Map<String, LetterStatus> initialKeyboardStatus() => {
      for (final key in keyboardLayout) key: LetterStatus.initial,
    };
