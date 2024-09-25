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
            SharedPreferencesKeys.values.map((e) => e.name).toSet(),
      ),
    );
  }

  Future<void> remove(SharedPreferencesKeys key) async {
    await _prefs.remove(key.name);
  }

  bool? getBool(SharedPreferencesKeys key) {
    return _prefs.getBool(key.name);
  }

  void setBool(SharedPreferencesKeys key, bool val) {
    _prefs.setBool(key.name, val);
  }

  String? getString(SharedPreferencesKeys key) {
    return _prefs.getString(key.name);
  }

  void setString(SharedPreferencesKeys key, String val) {
    _prefs.setString(key.name, val);
  }

  List<String>? getStringList(SharedPreferencesKeys key) {
    return _prefs.getStringList(key.name);
  }

  void setStringList(SharedPreferencesKeys key, List<String> val) {
    _prefs.setStringList(key.name, val);
  }
}
