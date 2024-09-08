enum SharedPreferencesKeys {
  isDarkMode,

  /// grid state, keeping track of all tiles etc
  gridState,

  /// The wordle date the grid is keep track of
  gameDate,

  /// Use standard wordle list or custom list
  useCustomList;

  @override
  String toString() => name;
}
