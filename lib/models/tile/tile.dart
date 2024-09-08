import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:red_owl/config/shared.dart' show LetterStatus;

part 'tile.freezed.dart';
part 'tile.g.dart';

@freezed
class Tile with _$Tile {
  const factory Tile({
    /// Letter
    required String letter,
    /// Tile status
    required LetterStatus status,
    /// did tile play Flip animation before
    required bool hasFlipAnimationPlayed,
  }) = _Tile;

  factory Tile.fromJson(Map<String, Object?> json) => _$TileFromJson(json);
}
