import 'package:shared_preferences/shared_preferences.dart';
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;

/// Singleton wrapper around [SharedPreferencesWithCache] that provides
/// typed read/write access keyed by [SharedPreferencesKeys].
///
/// The underlying [SharedPreferencesWithCache] is configured with an
/// allowlist derived from the [SharedPreferencesKeys] enum, so only
/// recognised keys can be stored.
///
/// Usage:
/// ```dart
/// await SharedPreferenceService().init();     // once, during app startup
/// SharedPreferenceService().setBool(SharedPreferencesKeys.isDarkMode, true);
/// bool? dark = SharedPreferenceService().getBool(SharedPreferencesKeys.isDarkMode);
/// ```
class SharedPreferenceService {
  late SharedPreferencesWithCache _prefs;

  /// The backing singleton instance.
  static final SharedPreferenceService _instance =
      SharedPreferenceService._internal();

  /// Returns the singleton [SharedPreferenceService] instance.
  factory SharedPreferenceService() => _instance;

  SharedPreferenceService._internal();

  /// Creates and caches a [SharedPreferencesWithCache] instance restricted to
  /// the keys declared in [SharedPreferencesKeys].
  ///
  /// Must be awaited before any read/write operations. Can be called again
  /// in tests (the field is non-final to allow re-initialisation with mocked
  /// platform data).
  Future<void> init() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(
        // Only these keys can be read from or written to the cache.
        allowList:
            SharedPreferencesKeys.values.map((e) => e.name).toSet(),
      ),
    );
  }

  /// Removes [key] from both the in-memory cache and persistent storage.
  Future<void> remove(SharedPreferencesKeys key) async {
    await _prefs.remove(key.name);
  }

  // ── Boolean ─────────────────────────────────────────────────────────────────

  /// Returns the boolean stored under [key], or `null` if not set.
  bool? getBool(SharedPreferencesKeys key) {
    return _prefs.getBool(key.name);
  }

  /// Writes [val] under [key] (fire-and-forget; errors are swallowed by
  /// the underlying implementation).
  void setBool(SharedPreferencesKeys key, bool val) {
    _prefs.setBool(key.name, val);
  }

  // ── String ──────────────────────────────────────────────────────────────────

  /// Returns the string stored under [key], or `null` if not set.
  String? getString(SharedPreferencesKeys key) {
    return _prefs.getString(key.name);
  }

  /// Writes [val] under [key].
  void setString(SharedPreferencesKeys key, String val) {
    _prefs.setString(key.name, val);
  }

  // ── String list ─────────────────────────────────────────────────────────────

  /// Returns the string list stored under [key], or `null` if not set.
  List<String>? getStringList(SharedPreferencesKeys key) {
    return _prefs.getStringList(key.name);
  }

  /// Writes [val] under [key].
  void setStringList(SharedPreferencesKeys key, List<String> val) {
    _prefs.setStringList(key.name, val);
  }
}
