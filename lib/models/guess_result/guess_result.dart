// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'guess_result.freezed.dart';
part 'guess_result.g.dart';

/// The full evaluation result returned by [WordleService.checkGuessWord].
///
/// Contains whether the guess was correct, whether the word was found in the
/// word list, and (when applicable) per-character scoring information used
/// to colour each tile.
@freezed
abstract class GuessResult with _$GuessResult {
  const factory GuessResult({
    /// The word the player submitted (uppercase).
    required String guess,

    /// Whether [guess] exactly matches today's word.
    @JsonKey(name: "is_correct") required bool isCorrect,

    /// Whether [guess] is a real word in the active word list.
    /// When false the player should be prompted and the row should not advance.
    @JsonKey(name: "is_word_in_list") required bool isWordInList,

    /// Per-character scoring, one entry per letter of [guess].
    /// Null when [isCorrect] is true (no individual scoring needed) or when
    /// the word is not in the list.
    @JsonKey(name: "character_info")
    required List<CharacterInfo>? characterInfo,
  }) = _GuessResult;

  /// Creates a [GuessResult] from the raw JSON map returned by
  /// [WordleService.checkGuessWord].
  factory GuessResult.fromJson(Map<String, Object?> json) =>
      _$GuessResultFromJson(json);
}

/// Scoring data for a single character in a guess.
@freezed
abstract class CharacterInfo with _$CharacterInfo {
  const factory CharacterInfo({
    /// The evaluated character (uppercase).
    required String char,

    /// Whether the character appears in the answer and/or is at the correct index.
    required CharacterScoring scoring,
  }) = _CharacterInfo;

  /// Deserialises a [CharacterInfo] from JSON.
  factory CharacterInfo.fromJson(Map<String, Object?> json) =>
      _$CharacterInfoFromJson(json);
}

/// Boolean flags describing how a guessed character relates to the answer.
@freezed
abstract class CharacterScoring with _$CharacterScoring {
  const factory CharacterScoring({
    /// Whether the character exists anywhere in the answer.
    /// A yellow tile has [inWord] = true but [correctIndex] = false.
    @JsonKey(name: "in_word") required bool inWord,

    /// Whether the character is at exactly the right position.
    /// A green tile has both [inWord] and [correctIndex] = true.
    @JsonKey(name: "correct_idx") required bool correctIndex,
  }) = _CharacterScoring;

  /// Deserialises a [CharacterScoring] from JSON.
  factory CharacterScoring.fromJson(Map<String, Object?> json) =>
      _$CharacterScoringFromJson(json);
}
