import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:red_owl/models/shared.dart' show Tile;
import 'package:red_owl/config/shared.dart' show LetterStatus;

part 'grid.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class Grid with _$Grid {
  const factory Grid({
    required int column,
    required int row,
    required List<Tile> tiles,
    required Map<String, LetterStatus> keyboardStatus,
    required bool runAnimation,
  }) = _Grid;
}
