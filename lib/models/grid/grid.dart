import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:red_owl/models/shared.dart' show Tile;
import 'package:red_owl/config/shared.dart' show LetterStatus;

part 'grid.freezed.dart';
part 'grid.g.dart';

/// Immutable snapshot of the entire game board at a point in time.
///
/// Managed by the [Grid] Riverpod notifier. All UI is rebuilt reactively
/// whenever a new [Grid] value is emitted. The object is also serialised to
/// Base64-encoded JSON and persisted to SharedPreferences after each move so
/// the game can be resumed across app restarts.
@freezed
abstract class Grid with _$Grid {
  const factory Grid({
    /// Zero-based column index of the tile that will receive the next key press.
    /// Resets to 0 after ENTER or DELETE.
    required int column,

    /// Zero-based row index of the current guess (0–5).
    /// Incremented after each valid guess is submitted.
    required int row,

    /// All tiles that have been placed so far.
    /// Length grows as the player types letters and shrinks on DELETE.
    /// A full board has exactly 30 tiles (5 columns × 6 rows).
    required List<Tile> tiles,

    /// Per-key evaluation status used to colour the on-screen keyboard.
    /// Mirrors the QWERTY layout from [keyboardStatus].
    required Map<String, LetterStatus> keyboardStatus,

    /// True while the tile flip animation should be (re-)started.
    /// Set to false once all tiles in the row have animated.
    required bool runFlipAnimation,

    /// True when the last key pressed was ENTER or DELETE.
    /// Suppresses the pop-in animation on the next rebuild.
    required bool isEnterOrDeletePressed,

    /// Whether the player solved the puzzle in the current session.
    required bool isGameWon,

    /// Whether the game has ended (either won or all 6 rows used up).
    required bool isGameOver,

    /// True when the player presses ENTER on a row with fewer than 5 letters.
    /// Triggers the shake animation on the current row.
    required bool notEnoughCharacters,

    /// Whether this board should be persisted to SharedPreferences after each
    /// move. The daily game persists (so it survives restarts); the practice
    /// board sets this to `false` so it never overwrites the saved daily game.
    /// Defaults to `true`, so existing serialized grids deserialize unchanged.
    @Default(true) bool persistState,
  }) = _Grid;

  /// Creates a [Grid] from a JSON map produced by [toJson].
  factory Grid.fromJson(Map<String, Object?> json) => _$GridFromJson(json);
}
