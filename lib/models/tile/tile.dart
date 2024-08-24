import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:red_owl/config/shared.dart' show LetterStatus;

part 'tile.freezed.dart';

@freezed
class Tile with _$Tile {
  const factory Tile({
    required String letter,
    required LetterStatus status,
  }) = _Tile;
}
