// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Tile _$TileFromJson(Map<String, dynamic> json) => _Tile(
  letter: json['letter'] as String,
  status: $enumDecode(_$LetterStatusEnumMap, json['status']),
  hasFlipAnimationPlayed: json['hasFlipAnimationPlayed'] as bool,
);

Map<String, dynamic> _$TileToJson(_Tile instance) => <String, dynamic>{
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
