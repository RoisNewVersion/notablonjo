import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  // helper getter
  static Future<SharedPreferences> get pref => SharedPreferences.getInstance();

  static Future<bool> getBool(String key) async {
    final p = await pref;
    return p.getBool(key) ?? false;
  }

  static Future setBool(String key, bool val) async {
    final p = await pref;
    return p.setBool(key, val);
  }

  static Future<int> getInt(String key) async {
    final p = await pref;
    return p.getInt(key) ?? 0;
  }

  static Future setInt(String key, int val) async {
    final p = await pref;
    return p.setInt(key, val);
  }

  static Future<String> getString(String key) async {
    final p = await pref;
    return p.getString(key) ?? '';
  }

  static Future setString(String key, String val) async {
    final p = await pref;
    return p.setString(key, val);
  }

  static Future<double> getDouble(String key) async {
    final p = await pref;
    return p.getDouble(key) ?? 0.0;
  }

  static Future setDouble(String key, double val) async {
    final p = await pref;
    return p.setDouble(key, val);
  }

  static Future remove(String key) async {
    final p = await pref;
    return p.remove(key);
  }
}
