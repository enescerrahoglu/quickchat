import 'package:flutter/material.dart';
import 'package:quickchat/components/list_view_component.dart';
import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/localization/language_localization.dart';
import 'package:quickchat/localization/language.dart';
import 'package:quickchat/main.dart';

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({Key? key}) : super(key: key);

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  Language? selectedLanguage;
  List<Language>? languages;
  Language? lang;

  @override
  void initState() {
    super.initState();
    languages = Language.languageList();
  }

  void _changeLanguage(Language language) async {
    Locale locale = await setLocale(language.languageCode);

    if (mounted) {}
    MyApp.setLocale(context, locale);
  }

  _setSelectedLang(Language lang) {
    setState(() {
      selectedLanguage = lang;
    });
  }

  Locale? _locale = const Locale("en");
  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
        selectedLanguage = languages!.firstWhere((element) => element.languageCode == _locale!.languageCode);
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ListViewComponent(
              itemList: languages!.map((language) {
            return ListViewItem(
                onTap: () async {
                  _setSelectedLang(selectedLanguage as Language);
                  _changeLanguage(language);
                  await Future.delayed(const Duration(microseconds: 1000), () {}).then((value) {
                    Navigator.pop(context);
                  });
                },
                title: language.name,
                prefixWidget: Radio(
                  activeColor: primaryColor,
                  value: language,
                  groupValue: selectedLanguage,
                  onChanged: (selectedLanguage) async {
                    _setSelectedLang(selectedLanguage as Language);
                    _changeLanguage(selectedLanguage);
                    await Future.delayed(const Duration(microseconds: 1000), () {}).then((value) {
                      Navigator.pop(context);
                    });
                  },
                ));
          }).toList()),
        ),
      ),
    );
  }
}
