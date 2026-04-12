/// Keys used to persist user preferences and game state in SharedPreferences.
///
/// Passed to [SharedPreferencesWithCache] as an allowlist so that only
/// these keys can be read from or written to the cache.
enum SharedPreferencesKeys {
  /// Whether dark mode is enabled (bool). Falls back to system brightness
  /// when not set.
  isDarkMode,

  /// Base64-encoded JSON snapshot of the current [Grid] state including
  /// all tiles, keyboard status, and game-over flags. Cleared when a new
  /// day starts.
  gridState,

  /// ISO-8601 date string (`yyyy-MM-dd`) of the day the current grid
  /// belongs to. Used to detect day rollover and reset the board.
  gameDate,

  /// Ordered list of four string-encoded integers:
  /// `[gamesPlayed, gamesWon, currentStreak, maxStreak]`.
  statsData,

  /// List of six string-encoded integers representing how many times
  /// the player won in 1, 2, 3, 4, 5, or 6 guesses respectively.
  /// Drives the bar chart on the Stats page.
  guessDistribution,

  /// Whether to use the user-imported custom word list instead of the
  /// bundled default list (bool).
  useCustomList,
}
