import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/config/shared.dart' show LetterStatus, keyboardStatus;
import 'package:red_owl/models/shared.dart' show Grid, Tile;

void main() {
  /// Helper that creates a default empty grid for testing.
  Grid makeEmptyGrid() {
    return Grid(
      column: 0,
      row: 0,
      tiles: const [],
      keyboardStatus: keyboardStatus,
      runFlipAnimation: false,
      isEnterOrDeletePressed: false,
      isGameWon: false,
      isGameOver: false,
      notEnoughCharacters: false,
    );
  }

  group('Grid', () {
    test('creates an empty grid with default values', () {
      final grid = makeEmptyGrid();
      expect(grid.column, 0);
      expect(grid.row, 0);
      expect(grid.tiles, isEmpty);
      expect(grid.runFlipAnimation, false);
      expect(grid.isGameWon, false);
      expect(grid.isGameOver, false);
      expect(grid.notEnoughCharacters, false);
    });

    test('keyboardStatus contains all 26 letters plus ENTER and DELETE', () {
      final grid = makeEmptyGrid();
      expect(grid.keyboardStatus.length, 28);
      expect(grid.keyboardStatus.containsKey('A'), true);
      expect(grid.keyboardStatus.containsKey('Z'), true);
      expect(grid.keyboardStatus.containsKey('ENTER'), true);
      expect(grid.keyboardStatus.containsKey('DELETE'), true);
    });

    test('all keyboard keys start with LetterStatus.initial', () {
      final grid = makeEmptyGrid();
      for (final entry in grid.keyboardStatus.entries) {
        expect(entry.value, LetterStatus.initial,
            reason: '${entry.key} should be initial');
      }
    });

    test('supports equality comparison', () {
      final grid1 = makeEmptyGrid();
      final grid2 = makeEmptyGrid();
      expect(grid1, equals(grid2));
    });

    test('copyWith updates column and row', () {
      final grid = makeEmptyGrid();
      final updated = grid.copyWith(column: 3, row: 1);
      expect(updated.column, 3);
      expect(updated.row, 1);
      expect(updated.tiles, isEmpty);
    });

    test('copyWith can add tiles', () {
      final grid = makeEmptyGrid();
      final newTiles = [
        const Tile(
          letter: 'H',
          status: LetterStatus.initial,
          hasFlipAnimationPlayed: false,
        ),
        const Tile(
          letter: 'E',
          status: LetterStatus.initial,
          hasFlipAnimationPlayed: false,
        ),
      ];
      final updated = grid.copyWith(tiles: newTiles, column: 2);
      expect(updated.tiles, hasLength(2));
      expect(updated.tiles[0].letter, 'H');
      expect(updated.tiles[1].letter, 'E');
    });

    test('copyWith sets game over state', () {
      final grid = makeEmptyGrid();
      final won = grid.copyWith(
        isGameWon: true,
        isGameOver: true,
      );
      expect(won.isGameWon, true);
      expect(won.isGameOver, true);
      expect(grid.isGameWon, false);
    });

    test('copyWith updates keyboard status', () {
      final grid = makeEmptyGrid();
      final newStatus = {...grid.keyboardStatus};
      newStatus['A'] = LetterStatus.green;
      newStatus['B'] = LetterStatus.yellow;
      newStatus['C'] = LetterStatus.notInWord;

      final updated = grid.copyWith(keyboardStatus: newStatus);
      expect(updated.keyboardStatus['A'], LetterStatus.green);
      expect(updated.keyboardStatus['B'], LetterStatus.yellow);
      expect(updated.keyboardStatus['C'], LetterStatus.notInWord);
      expect(updated.keyboardStatus['D'], LetterStatus.initial);
    });

    test('serializes to JSON and back via jsonEncode/jsonDecode', () {
      final grid = Grid(
        column: 2,
        row: 1,
        tiles: const [
          Tile(
            letter: 'T',
            status: LetterStatus.green,
            hasFlipAnimationPlayed: true,
          ),
          Tile(
            letter: 'E',
            status: LetterStatus.yellow,
            hasFlipAnimationPlayed: true,
          ),
        ],
        keyboardStatus: keyboardStatus,
        runFlipAnimation: false,
        isEnterOrDeletePressed: false,
        isGameWon: false,
        isGameOver: false,
        notEnoughCharacters: false,
      );
      final jsonString = jsonEncode(grid.toJson());
      final restored = Grid.fromJson(jsonDecode(jsonString));
      expect(restored, equals(grid));
    });

    test('JSON contains expected keys', () {
      final grid = makeEmptyGrid();
      final json = grid.toJson();
      expect(json.containsKey('column'), true);
      expect(json.containsKey('row'), true);
      expect(json.containsKey('tiles'), true);
      expect(json.containsKey('keyboardStatus'), true);
      expect(json.containsKey('runFlipAnimation'), true);
      expect(json.containsKey('isGameWon'), true);
      expect(json.containsKey('isGameOver'), true);
      expect(json.containsKey('notEnoughCharacters'), true);
    });

    test('tiles list is immutable via copyWith', () {
      final grid = makeEmptyGrid();
      final updated = grid.copyWith(
        tiles: [
          const Tile(
            letter: 'A',
            status: LetterStatus.initial,
            hasFlipAnimationPlayed: false,
          ),
        ],
        column: 1,
      );
      expect(grid.tiles, isEmpty);
      expect(updated.tiles, hasLength(1));
    });

    test('can represent a full 6-row game board', () {
      final tiles = List.generate(
        30,
        (i) => Tile(
          letter: String.fromCharCode(65 + (i % 26)),
          status: LetterStatus.notInWord,
          hasFlipAnimationPlayed: true,
        ),
      );
      final grid = Grid(
        column: 5,
        row: 6,
        tiles: tiles,
        keyboardStatus: keyboardStatus,
        runFlipAnimation: false,
        isEnterOrDeletePressed: false,
        isGameWon: false,
        isGameOver: true,
        notEnoughCharacters: false,
      );
      expect(grid.tiles, hasLength(30));
      expect(grid.isGameOver, true);
    });
  });
}
