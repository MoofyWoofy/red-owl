// Unit tests for buildEmojiGrid (the NYT-style share text).
import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/config/shared.dart' show LetterStatus;
import 'package:red_owl/models/shared.dart' show Tile;
import 'package:red_owl/util/shared.dart' show buildEmojiGrid;

/// Builds a row of 5 tiles from a list of statuses.
List<Tile> row(List<LetterStatus> statuses) => [
      for (final s in statuses)
        Tile(letter: 'A', status: s, hasFlipAnimationPlayed: true),
    ];

void main() {
  const g = LetterStatus.green;
  const y = LetterStatus.yellow;
  const n = LetterStatus.notInWord;

  test('renders a winning grid with the guess count', () {
    final tiles = [
      ...row([n, y, n, n, n]),
      ...row([g, g, g, g, g]),
    ];
    final out = buildEmojiGrid(
      tiles: tiles,
      isGameWon: true,
      colorBlind: false,
      titlePrefix: 'Red Owl 23/05/2024',
    );
    expect(out, 'Red Owl 23/05/2024 2/6\n⬛🟨⬛⬛⬛\n🟩🟩🟩🟩🟩');
  });

  test('renders X/6 for a loss', () {
    final tiles = row([n, n, n, n, n]);
    final out = buildEmojiGrid(
      tiles: tiles,
      isGameWon: false,
      colorBlind: false,
      titlePrefix: 'Red Owl',
    );
    expect(out, 'Red Owl X/6\n⬛⬛⬛⬛⬛');
  });

  test('uses the color-blind palette when enabled', () {
    final tiles = row([g, y, n, n, n]);
    final out = buildEmojiGrid(
      tiles: tiles,
      isGameWon: true,
      colorBlind: true,
      titlePrefix: 'Red Owl',
    );
    expect(out, 'Red Owl 1/6\n🟦🟧⬛⬛⬛');
  });

  test('omits the in-progress (unsubmitted) row', () {
    final tiles = [
      ...row([g, n, n, n, n]),
      // A partially-typed next row still has initial-status tiles.
      ...row([LetterStatus.initial, LetterStatus.initial, LetterStatus.initial,
          LetterStatus.initial, LetterStatus.initial]),
    ];
    final out = buildEmojiGrid(
      tiles: tiles,
      isGameWon: false,
      colorBlind: false,
      titlePrefix: 'Red Owl',
    );
    // Only the one submitted row is included.
    expect(out, 'Red Owl X/6\n🟩⬛⬛⬛⬛');
  });
}
