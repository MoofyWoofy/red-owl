// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'guess_result.freezed.dart';
part 'guess_result.g.dart';

@freezed
class GuessResult with _$GuessResult {
  const factory GuessResult({
    required String guess,
    @JsonKey(name: "is_correct") required bool isCorrect,
    @JsonKey(name: "is_word_in_list") required bool isWordInList,
    @JsonKey(name: "character_info")
    required List<CharacterInfo>? characterInfo,
  }) = _GuessResult;

  factory GuessResult.fromJson(Map<String, Object?> json) =>
      _$GuessResultFromJson(json);
}

@freezed
class CharacterInfo with _$CharacterInfo {
  const factory CharacterInfo(
      {required String char,
      required CharacterScoring scoring}) = _CharacterInfo;

  factory CharacterInfo.fromJson(Map<String, Object?> json) =>
      _$CharacterInfoFromJson(json);
}

@freezed
class CharacterScoring with _$CharacterScoring {
  const factory CharacterScoring({
    @JsonKey(name: "in_word") required bool inWord,
    @JsonKey(name: "correct_idx") required bool correctIndex,
  }) = _CharacterScoring;

  factory CharacterScoring.fromJson(Map<String, Object?> json) =>
      _$CharacterScoringFromJson(json);
}
