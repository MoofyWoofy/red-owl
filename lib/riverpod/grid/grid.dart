import 'dart:convert';

import 'package:flutter/widgets.dart' show BuildContext;
import 'package:red_owl/util/shared.dart'
    show
        SharedPreferenceService,
        WordleService,
        getDateOnly,
        showSnackBar,
        stringToDate;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:red_owl/models/shared.dart' as models;
import 'package:red_owl/config/shared.dart'
    show LetterStatus, SharedPreferencesKeys, keyboardStatus;

part 'grid.g.dart';

@riverpod
class Grid extends _$Grid {
  @override
  models.Grid build() {
    String? gridBase64 =
        SharedPreferenceService().getString(SharedPreferencesKeys.gridState);

    // get game date, so that we know whether to reset the grid or not.
    String? gameDateString =
        SharedPreferenceService().getString(SharedPreferencesKeys.gameDate);
    DateTime gameDate = gameDateString == null
        ? getDateOnly(DateTime.now())
        : getDateOnly(stringToDate(gameDateString));

    // get today's date
    DateTime today = getDateOnly(DateTime.now());

    if (gameDate != today) {
      gridBase64 = null;
      // Clear shared prefs
      SharedPreferenceService().remove(SharedPreferencesKeys.gridState);
    }

    if (gridBase64 == null) {
      return models.Grid(
        column: 0,
        row: 0,
        tiles: [],
        keyboardStatus: keyboardStatus,
        runFlipAnimation: false,
        isEnterOrDeletePressed: false,
        isGameWon: false,
        isGameOver: false,
        notEnoughCharacters: false,
      );
    } else {
      String gridJsonString = utf8.decode(base64.decode(gridBase64));
      return models.Grid.fromJson(jsonDecode(gridJsonString));
    }
  }

  Future<void> onKeyboardPressed({
    required String key,
    required BuildContext context,
  }) async {
    String guessWord = state.tiles
        .skip(state.row * 5)
        .take(5)
        .map((e) => e.letter)
        .join()
        .toUpperCase();

    switch (key) {
      case 'ENTER':
        if (state.column == 5) {
          state = state.copyWith(isEnterOrDeletePressed: true);

          var result = await getGuessResult(guessWord);
          var tiles = state.tiles.toList();
          var keyboardStatusTemp = {...state.keyboardStatus};

          if (result.isCorrect) {
            for (var i = state.row * 5; i < state.row * 5 + 5; i++) {
              tiles[i] = tiles[i].copyWith(status: LetterStatus.green);
              keyboardStatusTemp[tiles[i].letter] = LetterStatus.green;
            }
            if (context.mounted) {
              showSnackBar(context, 'You got it!');
            }
            state = state.copyWith(
              tiles: tiles,
              runFlipAnimation: true,
              isGameWon: true,
              isGameOver: true,
              notEnoughCharacters: false,
            );
            _updateKeyboard(keyboardStatusTemp);
          } else if (!result.isWordInList) {
            if (context.mounted) {
              showSnackBar(context, "'$guessWord' is not in wordlist");
              state = state;
            }
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
              if (context.mounted) {
                showSnackBar(context, 'Better luck next time');
              }
              // make keyboard grayed out
              state = state.copyWith(
                isGameWon: false,
                isGameOver: true,
              );
            }
            state = state.copyWith(
              column: 0,
              row: state.row + 1,
              tiles: tiles,
              runFlipAnimation: true,
              notEnoughCharacters: false,
            );
            _updateKeyboard(keyboardStatusTemp);
          }
        } else {
          // Not enough characters
          state = state.copyWith(notEnoughCharacters: true);
          if (context.mounted) {
            showSnackBar(context, 'Not enough letters');
          }
        }
        break;
      case 'DELETE':
        if (state.column > 0) {
          state = state.copyWith(
            column: state.column - 1,
            tiles: state.tiles.toList()..removeLast(),
            isEnterOrDeletePressed: true,
            notEnoughCharacters: false,
          );
        }
        break;
      default:
        if (state.column >= 0 && state.column < 5) {
          state = state.copyWith(
            column: state.column + 1,
            tiles: state.tiles.toList()
              ..add(models.Tile(
                letter: key,
                status: LetterStatus.initial,
                hasFlipAnimationPlayed: false,
              )),
            isEnterOrDeletePressed: false,
            notEnoughCharacters: false,
          );
        }
        break;
    }
  }

  Future<models.GuessResult> getGuessResult(String guess) async {
    return models.GuessResult.fromJson(
      await WordleService().checkGuessWord(guess),
    );
  }

  void updateState(models.Grid newState) => state = newState;

  void resetGrid() {
    // Clear game state from sharedPrefs
    SharedPreferenceService().remove(SharedPreferencesKeys.gridState);
    
    state = models.Grid(
      column: 0,
      row: 0,
      tiles: [],
      keyboardStatus: keyboardStatus,
      runFlipAnimation: false,
      isEnterOrDeletePressed: false,
      isGameWon: false,
      isGameOver: false,
      notEnoughCharacters: false,
    );
  }

  void _updateKeyboard(Map<String, LetterStatus> keyboardStatus) {
    state = state.copyWith(keyboardStatus: keyboardStatus);
  }
}
