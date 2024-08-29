import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:red_owl/models/shared.dart' as models;
import 'package:red_owl/config/shared.dart' show LetterStatus, keyboardStatus;
import 'package:http/http.dart' as http;

part 'grid.g.dart';

@riverpod
class Grid extends _$Grid {
  @override
  models.Grid build() {
    return models.Grid(
      column: 0,
      row: 0,
      tiles: [],
      keyboardStatus: keyboardStatus,
      runAnimation: false,
      isEnterOrBackPressed: false,
    );
  }

  Future<void> onKeyboardPressed({required String key}) async {
    switch (key) {
      case 'ENTER':
        if (state.column == 5) {
          String guess = state.tiles
              .skip(state.row * 5)
              .take(5)
              .map((e) => e.letter)
              .join()
              .toUpperCase();

          var result = await getGuessResult(guess);
          var tiles = state.tiles.toList();
          var keyboardStatusTemp = state.keyboardStatus;
// check result
          if (result.isCorrect) {
            print('answer is correct');
            for (var i = state.row * 5; i < state.row * 5 + 5; i++) {
              tiles[i] = tiles[i].copyWith(status: LetterStatus.green);
              keyboardStatusTemp[tiles[i].letter] = LetterStatus.green;
            }
            state = state.copyWith(
              column: -1,
              row: -1,
              tiles: tiles,
              keyboardStatus: keyboardStatusTemp,
              runAnimation: true,
              isEnterOrBackPressed: true,
            );
          } else if (!result.isWordInList) {
            print('"word" is not in wordlist');
          } else {
            for (var i = state.row * 5; i < state.row * 5 + 5; i++) {
              if (result.characterInfo![i % 5].scoring.correctIndex) {
                // Correct Index
                tiles[i] = tiles[i].copyWith(status: LetterStatus.green);
                keyboardStatusTemp[tiles[i].letter] = LetterStatus.green;
              } else if (result.characterInfo![i % 5].scoring.inWord) {
                // In word
                tiles[i] = tiles[i].copyWith(status: LetterStatus.yellow);
                if (keyboardStatusTemp[tiles[i].letter] != LetterStatus.green) {
                  keyboardStatusTemp[tiles[i].letter] = LetterStatus.yellow;
                }
              } else {
                // not in word
                tiles[i] = tiles[i].copyWith(status: LetterStatus.notInWord);
                keyboardStatusTemp[tiles[i].letter] = LetterStatus.notInWord;
              }
            }
            if (state.row + 1 == 6) {
              // lose game
              print('lost the game');
              // make keyboard grayed out
            }
            state = state.copyWith(
              column: 0,
              row: state.row + 1,
              tiles: tiles,
              keyboardStatus: keyboardStatusTemp,
              runAnimation: true,
            );
          }
        }
        break;
      case 'DELETE':
        if (state.column > 0) {
          state = state.copyWith(
              column: state.column - 1,
            tiles: state.tiles.toList()..removeLast(),
            isEnterOrBackPressed: true,
          );
        }
        break;
      default:
        if (state.column >= 0 && state.column < 5) {
          state = state.copyWith(
            column: state.column + 1,
            tiles: state.tiles.toList()
              ..add(models.Tile(letter: key, status: LetterStatus.initial)),
            isEnterOrBackPressed: false,
          );
        }
        break;
    }
  }

  Future<models.GuessResult> getGuessResult(String guess) async {
    final response = await http.post(
      Uri.https('wordle-api-kappa.vercel.app', '/$guess'),
      headers: {'Content-Type': 'application/json'},
    );
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return models.GuessResult.fromJson(json);
  }

  void setRunAnimationValue(bool value) =>
      state = state.copyWith(runAnimation: value);
}
