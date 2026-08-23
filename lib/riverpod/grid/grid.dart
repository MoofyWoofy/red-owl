import 'dart:async' show unawaited;
import 'dart:convert';

import 'package:drift/drift.dart' show InsertMode;
import 'package:red_owl/l10n/app_localizations.dart' show AppLocalizations;
import 'package:red_owl/database/database.dart';
import 'package:red_owl/util/misc.dart';
import 'package:red_owl/util/shared.dart'
    show
        SharedPreferenceService,
        WordleService,
        getDateOnly,
        isStreakMilestone,
        stringToDate;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:red_owl/models/shared.dart' as models;
import 'package:red_owl/config/shared.dart'
    show LetterStatus, SharedPreferencesKeys, initialKeyboardStatus;

part 'grid.g.dart';

/// How the board reports user-facing feedback without reaching into the widget
/// tree.
///
/// The board's messages are localised, and several are parameterised (the
/// rejected word, the hard-mode constraint that was broken, the streak that was
/// reached), so the notifier needs [AppLocalizations] to build them. It does
/// **not** need a [BuildContext]: taking one mixed the UI into the business
/// logic and tied a notifier that outlives any single page to a context that
/// can be popped mid-guess, which is why every call site had to be paired with
/// a `context.mounted` check.
///
/// The widget supplies [show], so deciding whether a message can still be
/// displayed stays where the widget tree is.
class GameMessenger {
  const GameMessenger({required this.l10n, required this.show});

  /// Localised strings for the active locale.
  final AppLocalizations l10n;

  /// Displays [message] for [seconds].
  final void Function(String message, int seconds) show;
}

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
  /// Decodes a board persisted by the [Tile] widget, or returns `null` when the
  /// stored value cannot be read.
  ///
  /// The value is base64-wrapped JSON, and every layer of that can fail on a
  /// value that is already on disk: a partial write leaves invalid base64, a
  /// downgrade to a build with a different model shape leaves JSON that
  /// `fromJson` rejects, and a hand-edited backup can leave anything at all.
  /// Letting any of those throw out of [build] puts `gridProvider` into an
  /// error state, and because the bad value stays persisted it does so again on
  /// every launch — leaving no way out but clearing the app's data (and with it
  /// the player's stats). Treat an unreadable board as no saved game instead.
  static models.Grid? _decodeGrid(String encoded) {
    try {
      return models.Grid.fromJson(
          jsonDecode(utf8.decode(base64.decode(encoded))));
    } catch (_) {
      // Deliberately broad: base64, utf8 and jsonDecode each throw
      // FormatException, while `fromJson` throws a TypeError on a shape it does
      // not recognise. They are all the same problem here.
      return null;
    }
  }

  /// Parses a persisted `yyyy-MM-dd` stamp, or returns `null` when it is not a
  /// readable date. Corrupt just like [_decodeGrid]'s input, and just as fatal
  /// to [build] if it were allowed to throw.
  static DateTime? _decodeDate(String raw) {
    try {
      return getDateOnly(stringToDate(raw));
    } on FormatException {
      return null;
    }
  }

  /// A blank board.
  models.Grid _emptyBoard() => models.Grid(
        column: 0,
        row: 0,
        tiles: [],
        keyboardStatus: initialKeyboardStatus(),
        runFlipAnimation: false,
        isEnterOrDeletePressed: false,
        isGameWon: false,
        isGameOver: false,
        notEnoughCharacters: false,
      );

  /// Rehydrates the game board from SharedPreferences on app startup.
  ///
  /// Handles the day-rollover scenario: if the stored [gameDate] is before
  /// today and the game was not yet over, the partial game is written to the
  /// database as [GameState.incomplete] before a fresh grid is returned.
  ///
  /// Both persisted values are decoded defensively — see [_decodeGrid].
  @override
  models.Grid build() {
    final prefs = SharedPreferenceService();
    final today = getDateOnly(DateTime.now());

    final storedGridRaw = prefs.getString(SharedPreferencesKeys.gridState);
    final storedGrid =
        storedGridRaw == null ? null : _decodeGrid(storedGridRaw);
    final storedDateRaw = prefs.getString(SharedPreferencesKeys.gameDate);
    final storedDate =
        storedDateRaw == null ? null : _decodeDate(storedDateRaw);

    // Present but unreadable, as opposed to simply absent.
    final gridUnreadable = storedGridRaw != null && storedGrid == null;
    final dateUnreadable = storedDateRaw != null && storedDate == null;

    // A *missing* date means a board saved before any stamp was written; keep
    // treating that as today's board. An *unreadable* one is different: there
    // is no way to tell which day the board belongs to, so it can neither be
    // trusted as today's nor archived under a known date.
    final gameDate = storedDate ?? today;
    final rolledOver = gameDate != today;

    if (rolledOver || dateUnreadable || gridUnreadable) {
      // Archive an unfinished board only when the day it belongs to is known.
      if (rolledOver && storedGrid != null && !storedGrid.isGameOver) {
        // `build` is synchronous, so this write cannot be awaited; make that
        // explicit and swallow failures rather than letting them surface as
        // an unhandled async error that takes down the zone. Losing one
        // archived row is not worth crashing the app on startup.
        unawaited(
          _addToDatabase(gameState: GameState.incomplete, date: gameDate)
              .catchError((Object _) {}),
        );
      }

      // Stamp today and drop the stale or unreadable board, so a poisoned value
      // is cleared instead of being re-read on every launch.
      prefs.setString(
          SharedPreferencesKeys.gameDate, dateToString(DateTime.now()));
      unawaited(prefs
          .remove(SharedPreferencesKeys.gridState)
          .catchError((Object _) {}));
      return _emptyBoard();
    }

    return storedGrid ?? _emptyBoard();
  }

  /// Set while an ENTER press is being evaluated.
  ///
  /// Evaluation awaits [getGuessResult] partway through. Any key handled during
  /// that await would mutate `state`, and the writes after the await index the
  /// tile list by row — a DELETE arriving mid-evaluation shortens the row and
  /// the scored writes then run off the end of the list. Input is ignored until
  /// the guess is committed; this does not affect typing during the flip
  /// animation, which happens after the evaluation completes.
  bool _isEvaluatingGuess = false;

  /// Handles a key press from the on-screen keyboard or a hardware keyboard.
  ///
  /// - **Letter (A-Z)**: adds a [models.Tile] to the current row (up to 5).
  /// - **DELETE**: removes the last tile if the row is not empty.
  /// - **ENTER**: evaluates the guess when the row has exactly 5 letters.
  ///   Updates tile colors, keyboard status, win/loss state, stats, and the
  ///   history database. Shows a snack bar feedback message.
  Future<void> onKeyboardPressed({
    required String key,
    required GameMessenger messenger,
  }) async {
    if (_isEvaluatingGuess) return;

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
          final hardModeError = _hardModeViolation(messenger.l10n, guessWord);
          if (hardModeError != null) {
            // Reuse the shake animation to signal the invalid guess.
            state = state.copyWith(notEnoughCharacters: true);
            messenger.show(hardModeError, 3);
            break;
          }

          // Mark that ENTER was pressed so the pop-in animation is suppressed.
          state = state.copyWith(isEnterOrDeletePressed: true);

          // The row this guess belongs to, pinned before the await so the
          // writes below cannot land on a different row.
          final row = state.row;

          _isEvaluatingGuess = true;
          final models.GuessResult result;
          try {
            result = await getGuessResult(guessWord);
          } finally {
            _isEvaluatingGuess = false;
          }
          var tiles = state.tiles.toList();
          var keyboardStatusTemp = {...state.keyboardStatus};

          if (result.isCorrect) {
            // ── Correct guess ──────────────────────────────────────────────
            for (var i = row * 5; i < row * 5 + 5; i++) {
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
            // Normalised: indexing the stored list directly would throw a
            // RangeError if it were shorter than four entries.
            final streak = state.persistState
                ? int.parse(normalizeCounters(
                    SharedPreferenceService()
                        .getStringList(SharedPreferencesKeys.statsData),
                    statsDataLength,
                  )[2])
                : 0;
            if (isStreakMilestone(streak)) {
              messenger.show(messenger.l10n.streakMilestone(streak), 3);
            } else {
              messenger.show(messenger.l10n.youGotIt, 2);
            }
          } else if (!result.isWordInList) {
            // ── Word not in list ───────────────────────────────────────────
            // Reuse the notEnoughCharacters flag to trigger the shake animation.
            state = state.copyWith(notEnoughCharacters: true);
            messenger.show(messenger.l10n.notInWordList(guessWord), 2);
          } else {
            // ── Valid word, evaluate each character ────────────────────────
            for (var i = row * 5; i < row * 5 + 5; i++) {
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
            if (row + 1 == 6) {
              // Player used all 6 rows without winning — game over.
              messenger.show(messenger.l10n.betterLuckNextTime, 2);
              state = state.copyWith(
                isGameWon: false,
                isGameOver: true,
              );
              await recordOutcome(gameWon: false);
            }
            // Advance to the next row and trigger the flip animation.
            state = state.copyWith(
              column: 0,
              row: row + 1,
              tiles: tiles,
              runFlipAnimation: true,
              notEnoughCharacters: false,
            );
            _updateKeyboard(keyboardStatusTemp);
          }
        } else {
          // Row does not have 5 letters — trigger shake animation.
          state = state.copyWith(notEnoughCharacters: true);
          messenger.show(messenger.l10n.notEnoughLetters, 2);
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
  String? _hardModeViolation(AppLocalizations l10n, String guessWord) {
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
        return l10n.hardModeLetterMustBe(position + 1, expected);
      }
    }
    // Then presence constraints.
    for (final letter in requiredPresent) {
      if (!guessWord.contains(letter)) {
        return l10n.hardModeMustContain(letter);
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
  }

  /// Directly replaces the board state. Used by the [Tile] widget after the
  /// flip animation completes to mark all tiles as `hasFlipAnimationPlayed`.
  void updateState(models.Grid newState) => state = newState;

  /// Resets the board to an empty grid and clears the persisted grid state.
  ///
  /// Called from the Settings page when the user switches word lists while
  /// a game is in progress (after confirming the confirmation dialog).
  void resetGrid() {
    // Observed rather than dropped: `remove` is async, and an unobserved
    // rejection surfaces as an unhandled error in the zone rather than at the
    // call site. Clearing the saved board is best-effort -- the fresh state
    // below is what the player sees either way.
    unawaited(SharedPreferenceService()
        .remove(SharedPreferencesKeys.gridState)
        .catchError((Object _) {}));

    state = _emptyBoard();
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
    // Read the stored arrays defensively. `BackupService` rejects malformed
    // stats on import, but an install that ran an older build may already hold
    // a short or non-numeric array, and this runs on every finished game —
    // rebuilding from zero beats throwing and breaking the board.
    // `normalizeCounters` is shared with the Stats page readers so the writer
    // and the readers cannot drift apart on the expected shape.
    final storedStats = normalizeCounters(
      SharedPreferenceService().getStringList(SharedPreferencesKeys.statsData),
      statsDataLength,
    );
    final storedDistribution = normalizeCounters(
      SharedPreferenceService()
          .getStringList(SharedPreferencesKeys.guessDistribution),
      guessDistributionLength,
    );

    var gamesPlayed = int.parse(storedStats[0]);
    var gamesWon = int.parse(storedStats[1]);
    var currentStreak = int.parse(storedStats[2]);
    var maxStreak = int.parse(storedStats[3]);
    final guessDistribution =
        storedDistribution.map(int.parse).toList();

    gamesPlayed += 1;

    if (gameWon) {
      gamesWon += 1;
      currentStreak += 1;

      // Increment the bucket for the number of guesses taken (row is 0-based).
      if (state.row >= 0 && state.row < guessDistribution.length) {
        guessDistribution[state.row] += 1;
      }
    } else {
      // Streak breaks on any loss.
      currentStreak = 0;
    }

    // Max streak is the greater of the current and previous max.
    if (currentStreak > maxStreak) maxStreak = currentStreak;

    SharedPreferenceService().setStringList(
      SharedPreferencesKeys.statsData,
      [gamesPlayed, gamesWon, currentStreak, maxStreak]
          .map((value) => value.toString())
          .toList(),
    );
    SharedPreferenceService().setStringList(
      SharedPreferencesKeys.guessDistribution,
      guessDistribution.map((value) => value.toString()).toList(),
    );
  }

  /// Writes a [History] record to the Drift database.
  ///
  /// [gameState] describes the outcome; [date] defaults to today but can be
  /// overridden (used when archiving the previous day's incomplete game in
  /// [build]).
  ///
  /// Uses [InsertMode.insertOrReplace] because `date` is the table's primary
  /// key and a day can legitimately be recorded twice: `resetGrid()` restarts
  /// the board (word-list toggle, word-list import, backup restore) without
  /// clearing that day's existing row, so finishing the replacement game would
  /// otherwise raise `UNIQUE constraint failed: history.date`. The later result
  /// is the one the player actually finished, so replacing is correct.
  Future<void> _addToDatabase({
    required GameState gameState,
    DateTime? date,
  }) async {
    // Resolve the word for the given date so history shows the correct answer.
    final word = await WordleService().getWordOfTheDay(date);

    final database = AppDatabase();
    await database.into(database.history).insert(
          HistoryCompanion.insert(
            word: word,
            date: getDateOnly(date ?? DateTime.now()),
            gameState: gameState.name,
          ),
          mode: InsertMode.insertOrReplace,
        );
  }
}
