// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guess_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GuessResult _$GuessResultFromJson(Map<String, dynamic> json) => _GuessResult(
  guess: json['guess'] as String,
  isCorrect: json['is_correct'] as bool,
  isWordInList: json['is_word_in_list'] as bool,
  characterInfo: (json['character_info'] as List<dynamic>?)
      ?.map((e) => CharacterInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GuessResultToJson(_GuessResult instance) =>
    <String, dynamic>{
      'guess': instance.guess,
      'is_correct': instance.isCorrect,
      'is_word_in_list': instance.isWordInList,
      'character_info': instance.characterInfo,
    };

_CharacterInfo _$CharacterInfoFromJson(Map<String, dynamic> json) =>
    _CharacterInfo(
      char: json['char'] as String,
      scoring: CharacterScoring.fromJson(
        json['scoring'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CharacterInfoToJson(_CharacterInfo instance) =>
    <String, dynamic>{'char': instance.char, 'scoring': instance.scoring};

_CharacterScoring _$CharacterScoringFromJson(Map<String, dynamic> json) =>
    _CharacterScoring(
      inWord: json['in_word'] as bool,
      correctIndex: json['correct_idx'] as bool,
    );

Map<String, dynamic> _$CharacterScoringToJson(_CharacterScoring instance) =>
    <String, dynamic>{
      'in_word': instance.inWord,
      'correct_idx': instance.correctIndex,
    };
