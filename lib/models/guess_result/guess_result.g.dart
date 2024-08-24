// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guess_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GuessResultImpl _$$GuessResultImplFromJson(Map<String, dynamic> json) =>
    _$GuessResultImpl(
      guess: json['guess'] as String,
      isCorrect: json['is_correct'] as bool,
      isWordInList: json['is_word_in_list'] as bool,
      characterInfo: (json['character_info'] as List<dynamic>?)
          ?.map((e) => CharacterInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$GuessResultImplToJson(_$GuessResultImpl instance) =>
    <String, dynamic>{
      'guess': instance.guess,
      'is_correct': instance.isCorrect,
      'is_word_in_list': instance.isWordInList,
      'character_info': instance.characterInfo,
    };

_$CharacterInfoImpl _$$CharacterInfoImplFromJson(Map<String, dynamic> json) =>
    _$CharacterInfoImpl(
      char: json['char'] as String,
      scoring:
          CharacterScoring.fromJson(json['scoring'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CharacterInfoImplToJson(_$CharacterInfoImpl instance) =>
    <String, dynamic>{
      'char': instance.char,
      'scoring': instance.scoring,
    };

_$CharacterScoringImpl _$$CharacterScoringImplFromJson(
        Map<String, dynamic> json) =>
    _$CharacterScoringImpl(
      inWord: json['in_word'] as bool,
      correctIndex: json['correct_idx'] as bool,
    );

Map<String, dynamic> _$$CharacterScoringImplToJson(
        _$CharacterScoringImpl instance) =>
    <String, dynamic>{
      'in_word': instance.inWord,
      'correct_idx': instance.correctIndex,
    };
