import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:red_owl/config/shared.dart' show LetterStatus;

part 'tile.freezed.dart';
part 'tile.g.dart';

/// Immutable data class representing a single cell in the 5×6 Wordle grid.
///
/// A tile holds the character the player typed, the evaluation result
/// ([LetterStatus]) once ENTER is pressed, and a flag that tracks whether
/// the flip reveal animation has already been played so it is not replayed
/// when the widget rebuilds.
///
/// Serialised to/from JSON via the generated [_$TileFromJson] / [_$TileToJson]
/// functions so the entire grid can be persisted to SharedPreferences.
@freezed
abstract class Tile with _$Tile {
  const factory Tile({
    /// The uppercase letter displayed in this tile (e.g. `'A'`).
    required String letter,

    /// Evaluation result assigned after the player submits a guess.
    required LetterStatus status,

    /// Whether the flip animation has already played for this tile.
    /// Once true, the tile always shows its [status] color immediately
    /// without re-animating on widget rebuilds.
    required bool hasFlipAnimationPlayed,
  }) = _Tile;

  /// Creates a [Tile] from a JSON map produced by [toJson].
  factory Tile.fromJson(Map<String, Object?> json) => _$TileFromJson(json);
}
