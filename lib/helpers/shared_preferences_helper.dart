import 'package:flutter/cupertino.dart';
import 'package:quickchat/constants/shared_preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<void> setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> setBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<void> remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  final Locale locale;
  SharedPreferencesHelper(this.locale);

  getSettingsSharedPreferencesValues() async {
    SharedPreferencesConstants.isDarkTheme = await SharedPreferencesHelper.getBool("isDarkTheme") ?? false;
    SharedPreferencesConstants.useDeviceTheme = await SharedPreferencesHelper.getBool("useDeviceTheme") ?? true;
    SharedPreferencesConstants.appLanguageCode = await SharedPreferencesHelper.getString("languageCode") ?? locale.languageCode;
  }
}
