import 'package:quickchat/constants/shared_preferences_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String languageCode = 'languageCode';
const String english = 'en';
const String turkish = 'tr';

Locale _locale(String languageCode) {
  switch (languageCode) {
    case english:
      return const Locale(english, 'US');
    case turkish:
      return const Locale(turkish, "TR");
    default:
      return const Locale(english, "US");
  }
}

Future<Locale> setLocale(String langCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(languageCode, langCode);
  return _locale(langCode);
}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String langCode = prefs.getString(languageCode) ?? SharedPreferencesConstants.appLanguageCode;
  return _locale(langCode);
}
