import 'package:red_owl/config/shared.dart' show LetterStatus;
import 'package:red_owl/models/shared.dart' show Tile;

/// Builds the NYT-style shareable emoji grid for a finished board.
///
/// Each completed guess row becomes a line of five squares:
/// - correct position → 🟩 (🟦 in color-blind mode)
/// - present, wrong position → 🟨 (🟧 in color-blind mode)
/// - absent → ⬛
///
/// The result is prefixed by [titlePrefix] (e.g. "Red Owl 23/05/2024") followed
/// by the score: the number of guesses on a win, or `X` on a loss.
///
/// Only fully-guessed rows are included, so a still-in-progress board yields
/// just the rows submitted so far.
String buildEmojiGrid({
  required List<Tile> tiles,
  required bool isGameWon,
  required bool colorBlind,
  required String titlePrefix,
}) {
  final rows = <String>[];
  for (var r = 0; r * 5 < tiles.length; r++) {
    final rowTiles = tiles.skip(r * 5).take(5).toList();
    if (rowTiles.length < 5 ||
        rowTiles.first.status == LetterStatus.initial) {
      // Reached the active (not-yet-submitted) row.
      break;
    }
    rows.add(rowTiles.map((t) => _emojiFor(t.status, colorBlind)).join());
  }

  final score = isGameWon ? '${rows.length}' : 'X';
  return ['$titlePrefix $score/6', ...rows].join('\n');
}

/// Maps a tile [status] to its share-grid emoji, honouring [colorBlind] mode.
String _emojiFor(LetterStatus status, bool colorBlind) {
  switch (status) {
    case LetterStatus.green:
      return colorBlind ? '🟦' : '🟩';
    case LetterStatus.yellow:
      return colorBlind ? '🟧' : '🟨';
    case LetterStatus.notInWord:
    case LetterStatus.initial:
      return '⬛';
  }
}
