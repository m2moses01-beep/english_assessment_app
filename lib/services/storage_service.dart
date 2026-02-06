import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData(String key, String value) async {
    if (_prefs == null) await init();
    return await _prefs!.setString(key, value);
  }

  static Future<String?> getData(String key) async {
    if (_prefs == null) await init();
    return _prefs!.getString(key);
  }

  static Future<bool> removeData(String key) async {
    if (_prefs == null) await init();
    return await _prefs!.remove(key);
  }

  static Future<bool> clearAll() async {
    if (_prefs == null) await init();
    return await _prefs!.clear();
  }
}
