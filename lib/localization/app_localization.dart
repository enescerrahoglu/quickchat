import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Localization {
  final Locale locale;

  Localization(this.locale);

  static Localization of(BuildContext context) {
    return Localizations.of(context, Localization);
  }

  late Map<dynamic, dynamic> _localizedValues;

  Future<void> load() async {
    String jsonStringValues = await rootBundle.loadString('lib/localization/languages/${locale.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizedValues = mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String translate(String key) {
    return _localizedValues[key];
  }

  static const LocalizationsDelegate<Localization> delegate = _LocalizationsDelegate();
}

class _LocalizationsDelegate extends LocalizationsDelegate<Localization> {
  const _LocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'tr'].contains(locale.languageCode);
  }

  @override
  Future<Localization> load(Locale locale) async {
    Localization localization = Localization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<Localization> old) => false;
}

String getTranslated(BuildContext context, String key) {
  try {
    return Localization.of(context).translate(key);
  } catch (e) {
    return key;
  }
}
