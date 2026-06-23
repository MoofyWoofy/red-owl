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

  /// Whether the color-blind / high-contrast palette is enabled (bool).
  /// Swaps the green/yellow tile colors for a blue/orange palette and raises
  /// border contrast app-wide.
  isColorBlindMode,

  /// The user's chosen UI language as a locale code (`'en'`, `'nl'`), or
  /// `'system'`/absent to follow the device language (String).
  localeCode,

  /// The user's preferred text size as a scale code
  /// (`'small'`, `'normal'`, `'large'`, `'xlarge'`). Applied app-wide via a
  /// [TextScaler]. Absent → `'normal'` (String).
  fontScale,

  /// The user's animation-speed preference as a code
  /// (`'reduced'`, `'fast'`, `'normal'`, `'slow'`). Maps to a global
  /// `timeDilation`. Absent → `'normal'`. The system "remove animations"
  /// accessibility setting forces `'reduced'` regardless (String).
  motionSpeed,

  /// Whether hard mode is enabled (bool). In hard mode every revealed hint
  /// must be reused in subsequent guesses. The toggle locks once the first
  /// guess of the day is made. Absent → `false`.
  isHardMode,

  /// ISO-8601 date string (`yyyy-MM-dd`) of the day the player last used the
  /// once-per-day hint. When it differs from today, a hint is available again.
  hintUsedDate,

  /// Whether the opt-in daily reminder notification is enabled (bool).
  /// Absent → `false`.
  reminderEnabled,

  /// The daily reminder time as a `HH:mm` 24-hour string. Absent → `20:00`.
  reminderTime,

  /// ISO-8601 date string (`yyyy-MM-dd`) of the day the player last completed
  /// the daily game. Used to skip the reminder on days already played.
  lastPlayedDate,
}
