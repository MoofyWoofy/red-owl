import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:red_owl/models/shared.dart' as models show Grid, Tile;
import 'package:red_owl/config/shared.dart' show LetterStatus;

part 'grid.g.dart';

@riverpod
class Grid extends _$Grid {
  @override
  models.Grid build() {
    return const models.Grid(column: 0, row: 0, tiles: []);
  }

  onKeyboardPressed({required String key}) {
    switch (key) {
      case 'ENTER':
        if (state.column == 5) {
          state = state.copyWith(column: 0, row: state.row + 1);
        }
        break;
      case 'DELETE':
        if (state.column > 0) {
          state = state.copyWith(
              column: state.column - 1,
              tiles: state.tiles.toList()..removeLast());
        }
        break;
      default:
        if (state.column < 5) {
          state = state.copyWith(
            column: state.column + 1,
            tiles: state.tiles.toList()
              ..add(models.Tile(letter: key, status: LetterStatus.initial)),
          );
        }
        break;
    }
  }

  insertTile(models.Tile tile) {}
}
