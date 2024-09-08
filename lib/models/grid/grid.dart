import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:red_owl/models/shared.dart' show Tile;
import 'package:red_owl/config/shared.dart' show LetterStatus;

part 'grid.freezed.dart';
part 'grid.g.dart';

@freezed
class Grid with _$Grid {
  const factory Grid({
    /// current grid column.
    required int column,

    /// current grid row.
    required int row,

    /// List of all tiles in grid.
    required List<Tile> tiles,

    /// Keyboard status, green/yellow etc.
    required Map<String, LetterStatus> keyboardStatus,

    /// Run flip animation (when checking word).
    required bool runFlipAnimation,

    /// Check if letter pressed is ENTER or DELETE.
    required bool isEnterOrDeletePressed,

    /// Did player win the game?
    required bool isGameWon,

    /// Is the game over?
    required bool isGameOver,

    /// Does the row have 5 character to check word?
    required bool notEnoughCharacters,
  }) = _Grid;

  factory Grid.fromJson(Map<String, Object?> json) => _$GridFromJson(json);
}
