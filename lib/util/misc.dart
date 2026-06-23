import 'package:intl/intl.dart';

import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/models/shared.dart' show Grid;
import 'package:red_owl/util/shared_preference_service.dart'
    show SharedPreferenceService;

/// Formats [date] as an ISO-8601 date string (`yyyy-MM-dd`).
///
/// Example: `DateTime(2024, 5, 23)` → `'2024-05-23'`.
/// Used when persisting [SharedPreferencesKeys.gameDate] and when displaying
/// the current date in the GamePage AppBar.
String dateToString(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

/// Parses an ISO-8601 date string (`yyyy-MM-dd`) back into a [DateTime].
///
/// The inverse of [dateToString]. Throws if the string is not valid ISO-8601.
DateTime stringToDate(String date) => DateTime.parse(date);

/// Strips the time portion from [date], returning midnight on the same day.
///
/// Allows safe date-equality comparisons regardless of the time component.
/// Example: `getDateOnly(DateTime(2024, 5, 23, 14, 30))` → `DateTime(2024, 5, 23)`.
DateTime getDateOnly(DateTime date) =>
    DateTime(date.year, date.month, date.day);

/// Converts a list of string-encoded numbers to a list of doubles.
///
/// Used to convert the raw `guessDistribution` strings stored in
/// SharedPreferences into numeric values accepted by the fl_chart library.
///
/// Example: `['1', '2', '3']` → `[1.0, 2.0, 3.0]`.
List<double> convertListStringToListDouble(List<String> arg) =>
    arg.map((e) => double.parse(e)).toList();

/// Returns `true` if the player has started but not finished today's game.
///
/// A game is considered in-progress when the board has at least one tile
/// AND the game-over flag is not set. This is used by the Settings page to
/// warn the player before destructive actions (e.g. changing the word list).
bool isGameInProgress(Grid grid) {
  return grid.tiles.isNotEmpty && !grid.isGameOver;
}

/// Whether today's daily game has already been completed.
///
/// Reads [SharedPreferencesKeys.lastPlayedDate] (written when a daily game
/// finishes) and compares it to today. Used to decide whether the daily
/// reminder should skip today.
bool hasPlayedDailyToday() {
  final raw = SharedPreferenceService()
      .getString(SharedPreferencesKeys.lastPlayedDate);
  if (raw == null) return false;
  return getDateOnly(stringToDate(raw)) == getDateOnly(DateTime.now());
}

/// Notable streak lengths that earn a celebratory share prompt.
const Set<int> streakMilestones = {5, 10, 25, 50, 100, 200, 365, 500, 1000};

/// Whether [streak] is a celebrated milestone (see [streakMilestones]).
bool isStreakMilestone(int streak) => streakMilestones.contains(streak);

/// Computes the average number of guesses across won games from the stored
/// [guessDistribution] (six string-encoded counts for wins in 1–6 guesses).
///
/// Returns the average rounded to one decimal place, or `'0'` when no games
/// have been won yet (so it never divides by zero).
///
/// Example: distribution `['0','1','2','0','0','0']` → 1 win in 2 guesses and
/// 2 wins in 3 guesses → `(2 + 3 + 3) / 3` → `'2.7'`.
String getAverageGuesses(List<String> guessDistribution) {
  var totalWins = 0;
  var totalGuesses = 0;
  for (var i = 0; i < guessDistribution.length; i++) {
    final count = int.parse(guessDistribution[i]);
    totalWins += count;
    totalGuesses += count * (i + 1);
  }
  if (totalWins == 0) return '0';
  return (totalGuesses / totalWins).toStringAsFixed(1);
}

/// Computes the win rate as an integer percentage string (0–100).
///
/// Returns `'0'` when [wins] and [games] are both `'0'` to avoid
/// division-by-zero. Otherwise, rounds the result to the nearest integer.
///
/// Example: `getWinRate('7', '10')` → `'70'`.
String getWinRate(String wins, String games) {
  if (wins == '0' && games == '0') {
    return '0';
  } else {
    return (double.parse(wins) / double.parse(games) * 100).round().toString();
  }
}
