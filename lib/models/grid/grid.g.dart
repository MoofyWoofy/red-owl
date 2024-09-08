// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grid.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GridImpl _$$GridImplFromJson(Map<String, dynamic> json) => _$GridImpl(
      column: (json['column'] as num).toInt(),
      row: (json['row'] as num).toInt(),
      tiles: (json['tiles'] as List<dynamic>)
          .map((e) => Tile.fromJson(e as Map<String, dynamic>))
          .toList(),
      keyboardStatus: (json['keyboardStatus'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, $enumDecode(_$LetterStatusEnumMap, e)),
      ),
      runFlipAnimation: json['runFlipAnimation'] as bool,
      isEnterOrDeletePressed: json['isEnterOrDeletePressed'] as bool,
      isGameWon: json['isGameWon'] as bool,
      isGameOver: json['isGameOver'] as bool,
      notEnoughCharacters: json['notEnoughCharacters'] as bool,
    );

Map<String, dynamic> _$$GridImplToJson(_$GridImpl instance) =>
    <String, dynamic>{
      'column': instance.column,
      'row': instance.row,
      'tiles': instance.tiles,
      'keyboardStatus': instance.keyboardStatus
          .map((k, e) => MapEntry(k, _$LetterStatusEnumMap[e]!)),
      'runFlipAnimation': instance.runFlipAnimation,
      'isEnterOrDeletePressed': instance.isEnterOrDeletePressed,
      'isGameWon': instance.isGameWon,
      'isGameOver': instance.isGameOver,
      'notEnoughCharacters': instance.notEnoughCharacters,
    };

const _$LetterStatusEnumMap = {
  LetterStatus.initial: 'initial',
  LetterStatus.yellow: 'yellow',
  LetterStatus.green: 'green',
  LetterStatus.notInWord: 'notInWord',
};
