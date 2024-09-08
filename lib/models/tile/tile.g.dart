// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TileImpl _$$TileImplFromJson(Map<String, dynamic> json) => _$TileImpl(
      letter: json['letter'] as String,
      status: $enumDecode(_$LetterStatusEnumMap, json['status']),
      hasFlipAnimationPlayed: json['hasFlipAnimationPlayed'] as bool,
    );

Map<String, dynamic> _$$TileImplToJson(_$TileImpl instance) =>
    <String, dynamic>{
      'letter': instance.letter,
      'status': _$LetterStatusEnumMap[instance.status]!,
      'hasFlipAnimationPlayed': instance.hasFlipAnimationPlayed,
    };

const _$LetterStatusEnumMap = {
  LetterStatus.initial: 'initial',
  LetterStatus.yellow: 'yellow',
  LetterStatus.green: 'green',
  LetterStatus.notInWord: 'notInWord',
};
