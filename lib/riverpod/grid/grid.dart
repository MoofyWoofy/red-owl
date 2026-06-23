import 'dart:convert';

import 'package:flutter/widgets.dart' show BuildContext, Locale, WidgetsBinding;
import 'package:red_owl/database/database.dart';
import 'package:red_owl/l10n/app_localizations.dart'
    show AppLocalizations, lookupAppLocalizations;
import 'package:red_owl/riverpod/shared.dart'
    show localeProvider, parseReminderTime, defaultReminderTime;
import 'package:red_owl/util/misc.dart';
import 'package:red_owl/util/shared.dart'
    show
        Localization,
        NotificationService,
        SharedPreferenceService,
        WordleService,
        getDateOnly,
        isStreakMilestone,
        showSnackBar,
        stringToDate;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:red_owl/models/shared.dart' as models;
import 'package:red_owl/config/shared.dart'
    show LetterStatus, SharedPreferencesKeys, keyboardStatus;

part 'grid.g.dart';

/// Riverpod notifier that owns and mutates the entire game board state.
///
/// On first access [build] rehydrates any in-progress game from
/// SharedPreferences. If the stored game is from a previous day it is
/// archived to the [History] database and a fresh empty grid is returned.
///
/// All user actions funnel through [onKeyboardPressed]:
/// - **Letter key** → adds a tile.
/// - **DELETE** → removes the last tile.
/// - **ENTER** → evaluates the current row, updates tiles and keyboard colors,
///   checks win/loss conditions, persists stats, and writes the history record.
@riverpod
class Grid extends _$Grid {
  /// Rehydrates the game board from SharedPreferences on app startup.
  ///
  /// Handles the day-rollover scenario: if the stored [gameDate] is before
  /// today and the game was not yet over, the partial game is written to the
  /// database as [GameState.incomplete] before a fresh grid is returned.
  @override
  models.Grid build() {
    String? gridBase64 =
        SharedPreferenceService().getString(SharedPreferencesKeys.gridState);

    // Determine which day the saved grid belongs to.
    String? gameDateString =
        SharedPreferenceService().getString(SharedPreferencesKeys.gameDate);
    DateTime gameDate = gameDateString == null
        ? getDateOnly(DateTime.now())
        : getDateOnly(stringToDate(gameDateString));

    DateTime today = getDateOnly(DateTime.now());

    if (gameDate != today) {
      // Day has rolled over — archive the incomplete game if any data exists.
      if (gridBase64 != null) {
        String gridJsonString = utf8.decode(base64.decode(gridBase64));
        final grid = models.Grid.fromJson(jsonDecode(gridJsonString));
        if (!grid.isGameOver) {
          // Only save to history if the game was not already finished.
          _addToDatabase(gameState: GameState.incomplete, date: gameDate);
        }
      }

      // Advance gameDate to today and clear the stale grid.
      SharedPreferenceService().setString(
          SharedPreferencesKeys.gameDate, dateToString(DateTime.now()));
      gameDate = getDateOnly(DateTime.now());

      gridBase64 = null;
      SharedPreferenceService().remove(SharedPreferencesKeys.gridState);
    }

    if (gridBase64 == null) {
      // No saved game — start with a blank board.
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
      // Decode and deserialize the persisted grid.
      String gridJsonString = utf8.decode(base64.decode(gridBase64));
      return models.Grid.fromJson(jsonDecode(gridJsonString));
    }
  }

  /// Handles a key press from the on-screen keyboard or a hardware keyboard.
  ///
  /// - **Letter (A-Z)**: adds a [models.Tile] to the current row (up to 5).
  /// - **DELETE**: removes the last tile if the row is not empty.
  /// - **ENTER**: evaluates the guess when the row has exactly 5 letters.
  ///   Updates tile colors, keyboard status, win/loss state, stats, and the
  ///   history database. Shows a snack bar feedback message.
  Future<void> onKeyboardPressed({
    required String key,
    required BuildContext context,
  }) async {
    // Build the current guess from the tiles in the active row.
    String guessWord = state.tiles
        .skip(state.row * 5)
        .take(5)
        .map((e) => e.letter)
        .join()
        .toUpperCase();

    switch (key) {
      case 'ENTER':
        if (state.column == 5) {
          // Hard mode: enforce that previously revealed hints are reused.
          final hardModeError = _hardModeViolation(context, guessWord);
          if (hardModeError != null) {
            // Reuse the shake animation to signal the invalid guess.
            state = state.copyWith(notEnoughCharacters: true);
            if (context.mounted) {
              showSnackBar(context, hardModeError, 3);
            }
            break;
          }

          // Mark that ENTER was pressed so the pop-in animation is suppressed.
          state = state.copyWith(isEnterOrDeletePressed: true);

          var result = await getGuessResult(guessWord);
          var tiles = state.tiles.toList();
          var keyboardStatusTemp = {...state.keyboardStatus};

          if (result.isCorrect) {
            // ── Correct guess ──────────────────────────────────────────────
            for (var i = state.row * 5; i < state.row * 5 + 5; i++) {
              tiles[i] = tiles[i].copyWith(status: LetterStatus.green);
              keyboardStatusTemp[tiles[i].letter] = LetterStatus.green;
            }
            state = state.copyWith(
              tiles: tiles,
              runFlipAnimation: true,
              isGameWon: true,
              isGameOver: true,
              notEnoughCharacters: false,
            );
            _updateKeyboard(keyboardStatusTemp);
            await recordOutcome(gameWon: true);
            // The (daily-only) updated current streak; a milestone replaces the
            // generic win message with a celebration.
            final streak = state.persistState
                ? int.tryParse(SharedPreferenceService()
                            .getStringList(SharedPreferencesKeys.statsData)?[2] ??
                        '0') ??
                    0
                : 0;
            if (context.mounted) {
              if (isStreakMilestone(streak)) {
                showSnackBar(context, context.l10n.streakMilestone(streak), 3);
              } else {
                showSnackBar(context, 'You got it!');
              }
            }
          } else if (!result.isWordInList) {
            // ── Word not in list ───────────────────────────────────────────
            // Reuse the notEnoughCharacters flag to trigger the shake animation.
            state = state.copyWith(notEnoughCharacters: true);
            if (context.mounted) {
              showSnackBar(context, "'$guessWord' is not in wordlist");
            }
          } else {
            // ── Valid word, evaluate each character ────────────────────────
            for (var i = state.row * 5; i < state.row * 5 + 5; i++) {
              if (result.characterInfo![i % 5].scoring.correctIndex) {
                // Green: correct letter, correct position.
                tiles[i] = tiles[i].copyWith(status: LetterStatus.green);
                keyboardStatusTemp[tiles[i].letter] = LetterStatus.green;
              } else if (result.characterInfo![i % 5].scoring.inWord) {
                // Yellow: letter in answer but wrong position.
                tiles[i] = tiles[i].copyWith(status: LetterStatus.yellow);
                // Don't downgrade a green key to yellow.
                if (keyboardStatusTemp[tiles[i].letter] != LetterStatus.green) {
                  keyboardStatusTemp[tiles[i].letter] = LetterStatus.yellow;
                }
              } else {
                // Grey: letter not in answer.
                tiles[i] = tiles[i].copyWith(status: LetterStatus.notInWord);
                keyboardStatusTemp[tiles[i].letter] = LetterStatus.notInWord;
              }
            }
            if (state.row + 1 == 6) {
              // Player used all 6 rows without winning — game over.
              if (context.mounted) {
                showSnackBar(context, 'Better luck next time');
              }
              state = state.copyWith(
                isGameWon: false,
                isGameOver: true,
              );
              await recordOutcome(gameWon: false);
            }
            // Advance to the next row and trigger the flip animation.
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
          // Row does not have 5 letters — trigger shake animation.
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
        // Letter key — append a tile if the row is not full.
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

  /// Validates [guessWord] against the hard-mode ruleset, returning a localized
  /// error message describing the first violation, or `null` if the guess is
  /// allowed (or hard mode is off / no guesses made yet).
  ///
  /// Standard hard mode requires every revealed hint to be reused:
  /// - a letter previously marked green must stay in the same position;
  /// - a letter previously marked yellow (present) must appear somewhere.
  /// Grey letters are not restricted, matching the NYT ruleset.
  String? _hardModeViolation(BuildContext context, String guessWord) {
    final hardMode =
        SharedPreferenceService().getBool(SharedPreferencesKeys.isHardMode) ??
            false;
    if (!hardMode || state.row == 0) return null;

    // Derive the constraints from every committed tile so far.
    final requiredGreens = <int, String>{};
    final requiredPresent = <String>{};
    for (var i = 0; i < state.row * 5; i++) {
      final tile = state.tiles[i];
      final position = i % 5;
      final letter = tile.letter.toUpperCase();
      if (tile.status == LetterStatus.green) {
        requiredGreens[position] = letter;
      } else if (tile.status == LetterStatus.yellow) {
        requiredPresent.add(letter);
      }
    }

    // Position constraints take precedence, reported left to right.
    for (var position = 0; position < 5; position++) {
      final expected = requiredGreens[position];
      if (expected != null && guessWord[position] != expected) {
        return context.l10n.hardModeLetterMustBe(position + 1, expected);
      }
    }
    // Then presence constraints.
    for (final letter in requiredPresent) {
      if (!guessWord.contains(letter)) {
        return context.l10n.hardModeMustContain(letter);
      }
    }
    return null;
  }

  /// Delegates guess evaluation to [WordleService] and converts the raw
  /// JSON map into a typed [models.GuessResult].
  ///
  /// Evaluates against the word of the day. The practice notifier overrides
  /// this to score against its own random answer instead.
  Future<models.GuessResult> getGuessResult(String guess) async {
    return models.GuessResult.fromJson(
      await WordleService().checkGuessWord(guess),
    );
  }

  /// Records the finished game's outcome: updates the aggregate stats and
  /// writes a history row. The practice notifier overrides this to a no-op so
  /// unlimited play never affects stats or history.
  Future<void> recordOutcome({required bool gameWon}) async {
    _updateStatsData(gameWon: gameWon);
    await _addToDatabase(
        gameState: gameWon ? GameState.won : GameState.lost);
    // Mark today as played so an enable/time change later today also skips it.
    SharedPreferenceService().setString(
        SharedPreferencesKeys.lastPlayedDate, dateToString(DateTime.now()));
    // Today's game is done — push the next reminder to tomorrow so the player
    // isn't nudged to play what they've already played.
    await _skipReminderForToday();
  }

  /// Reschedules the daily reminder to start tomorrow, if it is enabled.
  ///
  /// Called after the player finishes today's game. The notification text is
  /// localised here (away from any [BuildContext]) via [lookupAppLocalizations]
  /// so it matches the user's chosen UI language. A no-op when the reminder is
  /// off; the practice notifier never reaches here since it overrides
  /// [recordOutcome].
  Future<void> _skipReminderForToday() async {
    final enabled = SharedPreferenceService()
            .getBool(SharedPreferencesKeys.reminderEnabled) ??
        false;
    if (!enabled) return;

    final time = parseReminderTime(SharedPreferenceService()
            .getString(SharedPreferencesKeys.reminderTime)) ??
        defaultReminderTime;
    final l10n = lookupAppLocalizations(_reminderLocale());
    await NotificationService().scheduleDailyReminder(
      hour: time.hour,
      minute: time.minute,
      title: l10n.appName,
      body: l10n.reminderBody,
      skipToday: true,
    );
  }

  /// The locale to localise the reminder text in: the user's override if set,
  /// otherwise the device language when supported, falling back to English.
  Locale _reminderLocale() {
    final override = ref.read(localeProvider);
    if (override != null) return override;
    final device = WidgetsBinding.instance.platformDispatcher.locale;
    final supported = AppLocalizations.supportedLocales
        .any((l) => l.languageCode == device.languageCode);
    return supported ? Locale(device.languageCode) : const Locale('en');
  }

  /// Directly replaces the board state. Used by the [Tile] widget after the
  /// flip animation completes to mark all tiles as `hasFlipAnimationPlayed`.
  void updateState(models.Grid newState) => state = newState;

  /// Resets the board to an empty grid and clears the persisted grid state.
  ///
  /// Called from the Settings page when the user switches word lists while
  /// a game is in progress (after confirming the confirmation dialog).
  void resetGrid() {
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

  /// Replaces the keyboard status map in the current state.
  ///
  /// Called after each valid guess row to colour the keys green/yellow/grey.
  void _updateKeyboard(Map<String, LetterStatus> keyboardStatus) {
    state = state.copyWith(keyboardStatus: keyboardStatus);
  }

  /// Reads, updates, and persists the stats arrays in SharedPreferences.
  ///
  /// Stats are stored as two string lists:
  /// - `statsData`: `[gamesPlayed, gamesWon, currentStreak, maxStreak]`
  /// - `guessDistribution`: counts for each guess count (1–6)
  ///
  /// On a win the current row index is used to increment the appropriate
  /// distribution bucket. On a loss the current streak resets to 0.
  void _updateStatsData({required bool gameWon}) {
    List<String> statsData = SharedPreferenceService()
            .getStringList(SharedPreferencesKeys.statsData) ??
        ['0', '0', '0', '0'];
    List<String> guessDistribution = SharedPreferenceService()
            .getStringList(SharedPreferencesKeys.guessDistribution) ??
        ['0', '0', '0', '0', '0', '0'];

    var [gamesPlayed, gamesWon, currentStreak, maxStreak] = statsData;

    gamesPlayed = (int.parse(gamesPlayed) + 1).toString();

    if (gameWon) {
      gamesWon = (int.parse(gamesWon) + 1).toString();
      currentStreak = (int.parse(currentStreak) + 1).toString();

      // Increment the bucket for the number of guesses taken (row is 0-based).
      guessDistribution[state.row] =
          (int.parse(guessDistribution[state.row]) + 1).toString();
    } else {
      // Streak breaks on any loss.
      currentStreak = '0';
    }

    // Max streak is the greater of the current and previous max.
    maxStreak = int.parse(currentStreak) > int.parse(maxStreak)
        ? currentStreak
        : maxStreak;

    SharedPreferenceService().setStringList(SharedPreferencesKeys.statsData,
        [gamesPlayed, gamesWon, currentStreak, maxStreak]);
    SharedPreferenceService().setStringList(
        SharedPreferencesKeys.guessDistribution, guessDistribution);
  }

  /// Writes a [History] record to the Drift database.
  ///
  /// [gameState] describes the outcome; [date] defaults to today but can be
  /// overridden (used when archiving the previous day's incomplete game in
  /// [build]).
  Future<void> _addToDatabase({
    required GameState gameState,
    DateTime? date,
  }) async {
    // Resolve the word for the given date so history shows the correct answer.
    final word = await WordleService().getWordOfTheDay(date);

    final database = AppDatabase();
    await database.into(database.history).insert(HistoryCompanion.insert(
          word: word,
          date: getDateOnly(date ?? DateTime.now()),
          gameState: gameState.name,
        ));
  }
}
