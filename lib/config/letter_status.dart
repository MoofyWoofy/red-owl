/// Visual feedback state for a single letter on the game grid or keyboard.
///
/// Used by both the tile grid and the on-screen keyboard to determine
/// background color and text styling.
enum LetterStatus {
  /// Default state before the letter has been checked against the answer.
  initial,

  /// The letter exists in the answer but is in the wrong position.
  yellow,

  /// The letter is in the correct position in the answer.
  green,

  /// The letter does not appear anywhere in the answer.
  notInWord,
}
