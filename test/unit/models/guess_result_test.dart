// Unit tests for the GuessResult, CharacterInfo, and CharacterScoring models.
//
// JSON keys use snake_case (@JsonKey annotations), so tests verify both the
// Dart field names and the serialized JSON key names.
// Round-trips use jsonDecode(jsonEncode(...)) to exercise the full Freezed
// serialization pipeline including nested objects.
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:red_owl/models/shared.dart'
    show CharacterInfo, CharacterScoring, GuessResult;

void main() {
  group('CharacterScoring', () {
    test('creates with required fields', () {
      const scoring = CharacterScoring(inWord: true, correctIndex: false);
      expect(scoring.inWord, true);
      expect(scoring.correctIndex, false);
    });

    test('supports equality', () {
      const a = CharacterScoring(inWord: true, correctIndex: true);
      const b = CharacterScoring(inWord: true, correctIndex: true);
      expect(a, equals(b));
    });

    test('serializes to JSON with snake_case keys', () {
      const scoring = CharacterScoring(inWord: true, correctIndex: false);
      final json = scoring.toJson();
      expect(json['in_word'], true);
      expect(json['correct_idx'], false);
    });

    test('deserializes from JSON with snake_case keys', () {
      final json = {'in_word': false, 'correct_idx': true};
      final scoring = CharacterScoring.fromJson(json);
      expect(scoring.inWord, false);
      expect(scoring.correctIndex, true);
    });

    test('round-trips through JSON', () {
      const original = CharacterScoring(inWord: true, correctIndex: true);
      final restored = CharacterScoring.fromJson(original.toJson());
      expect(restored, equals(original));
    });
  });

  group('CharacterInfo', () {
    test('creates with char and scoring', () {
      const info = CharacterInfo(
        char: 'A',
        scoring: CharacterScoring(inWord: true, correctIndex: false),
      );
      expect(info.char, 'A');
      expect(info.scoring.inWord, true);
    });

    test('supports equality with nested scoring', () {
      const a = CharacterInfo(
        char: 'B',
        scoring: CharacterScoring(inWord: false, correctIndex: false),
      );
      const b = CharacterInfo(
        char: 'B',
        scoring: CharacterScoring(inWord: false, correctIndex: false),
      );
      expect(a, equals(b));
    });

    test('serializes to JSON', () {
      const info = CharacterInfo(
        char: 'C',
        scoring: CharacterScoring(inWord: true, correctIndex: true),
      );
      final json = jsonDecode(jsonEncode(info.toJson())) as Map<String, dynamic>;
      expect(json['char'], 'C');
      expect(json['scoring'], isA<Map<String, dynamic>>());
      expect(json['scoring']['in_word'], true);
    });

    test('round-trips through JSON', () {
      const original = CharacterInfo(
        char: 'D',
        scoring: CharacterScoring(inWord: false, correctIndex: true),
      );
      final restored = CharacterInfo.fromJson(
        jsonDecode(jsonEncode(original.toJson())),
      );
      expect(restored, equals(original));
    });
  });

  group('GuessResult', () {
    test('creates a correct guess result', () {
      const result = GuessResult(
        guess: 'HELLO',
        isCorrect: true,
        isWordInList: true,
        characterInfo: null,
      );
      expect(result.guess, 'HELLO');
      expect(result.isCorrect, true);
      expect(result.isWordInList, true);
      expect(result.characterInfo, isNull);
    });

    test('creates a result with character info', () {
      const result = GuessResult(
        guess: 'WORLD',
        isCorrect: false,
        isWordInList: true,
        characterInfo: [
          CharacterInfo(
            char: 'W',
            scoring: CharacterScoring(inWord: true, correctIndex: true),
          ),
          CharacterInfo(
            char: 'O',
            scoring: CharacterScoring(inWord: false, correctIndex: false),
          ),
        ],
      );
      expect(result.characterInfo, hasLength(2));
      expect(result.characterInfo![0].char, 'W');
      expect(result.characterInfo![0].scoring.correctIndex, true);
    });

    test('creates a result for word not in list', () {
      const result = GuessResult(
        guess: 'ZZZZZ',
        isCorrect: false,
        isWordInList: false,
        characterInfo: null,
      );
      expect(result.isWordInList, false);
      expect(result.characterInfo, isNull);
    });

    test('serializes to JSON with snake_case keys', () {
      const result = GuessResult(
        guess: 'TESTS',
        isCorrect: false,
        isWordInList: true,
        characterInfo: null,
      );
      final json = result.toJson();
      expect(json['guess'], 'TESTS');
      expect(json['is_correct'], false);
      expect(json['is_word_in_list'], true);
      expect(json['character_info'], isNull);
    });

    test('round-trips through JSON', () {
      const original = GuessResult(
        guess: 'FLAME',
        isCorrect: false,
        isWordInList: true,
        characterInfo: [
          CharacterInfo(
            char: 'F',
            scoring: CharacterScoring(inWord: true, correctIndex: true),
          ),
          CharacterInfo(
            char: 'L',
            scoring: CharacterScoring(inWord: false, correctIndex: false),
          ),
          CharacterInfo(
            char: 'A',
            scoring: CharacterScoring(inWord: true, correctIndex: false),
          ),
          CharacterInfo(
            char: 'M',
            scoring: CharacterScoring(inWord: false, correctIndex: false),
          ),
          CharacterInfo(
            char: 'E',
            scoring: CharacterScoring(inWord: true, correctIndex: true),
          ),
        ],
      );
      final restored = GuessResult.fromJson(
        jsonDecode(jsonEncode(original.toJson())),
      );
      expect(restored, equals(original));
    });

    test('supports equality', () {
      const a = GuessResult(
        guess: 'EQUAL',
        isCorrect: true,
        isWordInList: true,
        characterInfo: null,
      );
      const b = GuessResult(
        guess: 'EQUAL',
        isCorrect: true,
        isWordInList: true,
        characterInfo: null,
      );
      expect(a, equals(b));
    });

    test('copyWith updates specific fields', () {
      const original = GuessResult(
        guess: 'START',
        isCorrect: false,
        isWordInList: true,
        characterInfo: null,
      );
      final updated = original.copyWith(isCorrect: true);
      expect(updated.isCorrect, true);
      expect(updated.guess, 'START');
    });
  });
}
