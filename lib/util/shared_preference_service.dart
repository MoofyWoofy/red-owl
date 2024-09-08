import 'package:shared_preferences/shared_preferences.dart';
import 'package:red_owl/config/shared.dart' show SharedPreferencesKeys;

class SharedPreferenceService {
  late final SharedPreferencesWithCache _prefs;

  static final SharedPreferenceService _instance =
      SharedPreferenceService._internal();

  factory SharedPreferenceService() => _instance;

  SharedPreferenceService._internal();

  Future<void> init() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(
        // When an allowlist is included, any keys that aren't included cannot be used.
        allowList:
            SharedPreferencesKeys.values.map((e) => e.toString()).toSet(),
      ),
    );
  }

  Future<void> remove(SharedPreferencesKeys key) async {
    await _prefs.remove(key.toString());
  }

  bool? getBool(SharedPreferencesKeys key) {
    return _prefs.getBool(key.toString());
  }

  void setBool(SharedPreferencesKeys key, bool val) {
    _prefs.setBool(key.toString(), val);
  }

  String? getString(SharedPreferencesKeys key) {
    return _prefs.getString(key.toString());
  }

  void setString(SharedPreferencesKeys key, String val) {
    _prefs.setString(key.toString(), val);
  }
}
