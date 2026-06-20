/// Unique identifiers for each [BoolFamilyNotifier] provider instance.
///
/// The Riverpod family provider pattern requires a stable ID to distinguish
/// between different instances. Using an enum instead of raw strings
/// eliminates typo-related bugs at compile time.
enum BoolFamilyProviderIDs {
  /// Provider controlling the dark mode toggle in Settings.
  isDarkMode,

  /// Provider controlling whether the custom word list is active.
  useCustomList,

  /// Provider controlling the color-blind / high-contrast palette toggle.
  isColorBlindMode,
}
