/// for Riverpod BoolFamilyProvider IDs, to prevent typo error.
enum BoolFamilyProviderIDs {
  isDarkMode,
  useCustomList;

  @override
  String toString() => name;
}
