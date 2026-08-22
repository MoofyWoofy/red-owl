
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;
import 'package:red_owl/models/shared.dart' show Grid;

/// Formats [date] as an ISO-8601 date string (`yyyy-MM-dd`).
///
/// Built from the numeric fields rather than `DateFormat`, which renders with
/// the ambient `Intl.defaultLocale`. This value is a storage key, not display
/// text: it is written to [SharedPreferencesKeys.gameDate] and read back by
/// [stringToDate] (`DateTime.parse`), so it has to stay ASCII digits in every
/// locale. Output is unchanged for all Gregorian dates.
///
/// Example: `DateTime(2024, 5, 23)` → `'2024-05-23'`.
String dateToString(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

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
/// Unparseable entries become `0` rather than throwing: the input comes from
/// persisted preferences, and a single bad value should render as an empty bar
/// instead of taking down the whole Stats page.
///
/// Example: `['1', '2', '3']` → `[1.0, 2.0, 3.0]`.
List<double> convertListStringToListDouble(List<String> arg) =>
    arg.map((e) => double.tryParse(e) ?? 0).toList();

/// Returns `true` if the player has started but not finished today's game.
///
/// A game is considered in-progress when the board has at least one tile
/// AND the game-over flag is not set. This is used by the Settings page to
/// warn the player before destructive actions (e.g. changing the word list).
bool isGameInProgress(Grid grid) {
  return grid.tiles.isNotEmpty && !grid.isGameOver;
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
    // Persisted values; treat anything unparseable as zero rather than throwing.
    final count = int.tryParse(guessDistribution[i]) ?? 0;
    totalWins += count;
    totalGuesses += count * (i + 1);
  }
  if (totalWins == 0) return '0';
  return (totalGuesses / totalWins).toStringAsFixed(1);
}

/// Computes the win rate as an integer percentage string (0–100).
///
/// Returns `'0'` whenever [games] is zero or unparseable. The previous guard
/// only caught the exact `'0'`/`'0'` pair, so any other zero-games input
/// divided by zero and `Infinity.round()` threw an [UnsupportedError].
/// Unparseable values are treated as zero rather than throwing, since both
/// come straight from persisted preferences.
///
/// Example: `getWinRate('7', '10')` → `'70'`.
String getWinRate(String wins, String games) {
  final gamesPlayed = double.tryParse(games) ?? 0;
  final gamesWon = double.tryParse(wins) ?? 0;
  if (gamesPlayed <= 0) return '0';
  return (gamesWon / gamesPlayed * 100).round().toString();
}
