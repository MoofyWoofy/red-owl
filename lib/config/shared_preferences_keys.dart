enum SharedPreferencesKeys {
  isDarkMode,

  /// grid state, keeping track of all tiles etc
  gridState,

  /// The wordle date the grid is keep track of
  gameDate,

  /// List<String> : games played, games won, current streak, max streak
  statsData,

  /// data for Stats graph
  guessDistribution,

  /// Use standard wordle list or custom list
  useCustomList,
}
