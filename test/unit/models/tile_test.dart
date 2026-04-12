import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/config/shared.dart' show LetterStatus;
import 'package:red_owl/models/shared.dart' show Tile;

void main() {
  group('Tile', () {
    test('creates a tile with required fields', () {
      const tile = Tile(
        letter: 'A',
        status: LetterStatus.initial,
        hasFlipAnimationPlayed: false,
      );
      expect(tile.letter, 'A');
      expect(tile.status, LetterStatus.initial);
      expect(tile.hasFlipAnimationPlayed, false);
    });

    test('supports equality comparison via freezed', () {
      const tile1 = Tile(
        letter: 'B',
        status: LetterStatus.green,
        hasFlipAnimationPlayed: true,
      );
      const tile2 = Tile(
        letter: 'B',
        status: LetterStatus.green,
        hasFlipAnimationPlayed: true,
      );
      expect(tile1, equals(tile2));
    });

    test('different tiles are not equal', () {
      const tile1 = Tile(
        letter: 'A',
        status: LetterStatus.green,
        hasFlipAnimationPlayed: false,
      );
      const tile2 = Tile(
        letter: 'B',
        status: LetterStatus.green,
        hasFlipAnimationPlayed: false,
      );
      expect(tile1, isNot(equals(tile2)));
    });

    test('copyWith creates a new tile with updated fields', () {
      const original = Tile(
        letter: 'A',
        status: LetterStatus.initial,
        hasFlipAnimationPlayed: false,
      );
      final updated = original.copyWith(status: LetterStatus.green);

      expect(updated.letter, 'A');
      expect(updated.status, LetterStatus.green);
      expect(updated.hasFlipAnimationPlayed, false);
      expect(original.status, LetterStatus.initial);
    });

    test('copyWith can update hasFlipAnimationPlayed', () {
      const original = Tile(
        letter: 'X',
        status: LetterStatus.yellow,
        hasFlipAnimationPlayed: false,
      );
      final updated = original.copyWith(hasFlipAnimationPlayed: true);
      expect(updated.hasFlipAnimationPlayed, true);
      expect(original.hasFlipAnimationPlayed, false);
    });

    test('serializes to JSON and back', () {
      const tile = Tile(
        letter: 'C',
        status: LetterStatus.yellow,
        hasFlipAnimationPlayed: true,
      );
      final json = tile.toJson();

      expect(json['letter'], 'C');
      expect(json['status'], 'yellow');
      expect(json['hasFlipAnimationPlayed'], true);

      final restored = Tile.fromJson(json);
      expect(restored, equals(tile));
    });

    test('fromJson handles all LetterStatus values', () {
      for (final status in LetterStatus.values) {
        final json = {
          'letter': 'Z',
          'status': status.name,
          'hasFlipAnimationPlayed': false,
        };
        final tile = Tile.fromJson(json);
        expect(tile.status, status);
      }
    });

    test('toString contains field values', () {
      const tile = Tile(
        letter: 'D',
        status: LetterStatus.notInWord,
        hasFlipAnimationPlayed: false,
      );
      final str = tile.toString();
      expect(str, contains('D'));
      expect(str, contains('notInWord'));
    });

    test('hashCode is consistent for equal tiles', () {
      const tile1 = Tile(
        letter: 'E',
        status: LetterStatus.initial,
        hasFlipAnimationPlayed: false,
      );
      const tile2 = Tile(
        letter: 'E',
        status: LetterStatus.initial,
        hasFlipAnimationPlayed: false,
      );
      expect(tile1.hashCode, equals(tile2.hashCode));
    });
  });
}
