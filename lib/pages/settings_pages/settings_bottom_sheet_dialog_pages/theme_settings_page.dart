import 'package:flutter/material.dart';
import 'package:quickchat/components/list_view_component.dart';
import 'package:quickchat/components/switch_component.dart';
import 'package:quickchat/constants/shared_preferences_constants.dart';
import 'package:quickchat/constants/string_constants.dart';
import 'package:quickchat/helpers/shared_preferences_helper.dart';
import 'package:quickchat/localization/app_localization.dart';
import 'package:provider/provider.dart' as provider;
import 'package:quickchat/providers/theme_provider.dart';

class ThemeSettingsPage extends StatefulWidget {
  const ThemeSettingsPage({Key? key}) : super(key: key);

  @override
  State<ThemeSettingsPage> createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  bool isLoading = true;

  setDarkTheme(bool isDarkThemeValue) async {
    await SharedPreferencesHelper.setBool("isDarkTheme", isDarkThemeValue);
  }

  setUseDeviceTheme(bool isDarkThemeValue) async {
    await SharedPreferencesHelper.setBool("useDeviceTheme", isDarkThemeValue);
  }

  @override
  Widget build(BuildContext context) {
    return provider.Consumer<ThemeProvider>(builder: (context, ThemeProvider themeProvider, child) {
      return Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: ListViewComponent(
                itemList: [
                  ListViewItem(
                    onTap: () {
                      setState(() {
                        setUseDeviceTheme(!SharedPreferencesConstants.useDeviceTheme);
                        SharedPreferencesConstants.useDeviceTheme = !SharedPreferencesConstants.useDeviceTheme;
                        themeProvider.toggleTheme();
                      });
                    },
                    title: getTranslated(context, ProfilePageKeys.useDeviceTheme),
                    suffixWidget: SwitchComponent(
                        switchValue: SharedPreferencesConstants.useDeviceTheme,
                        switchFunction: (value) {
                          setState(() {
                            setUseDeviceTheme(!SharedPreferencesConstants.useDeviceTheme);
                            SharedPreferencesConstants.useDeviceTheme = !SharedPreferencesConstants.useDeviceTheme;
                            themeProvider.toggleTheme();
                          });
                        }),
                  ),
                  SharedPreferencesConstants.useDeviceTheme == false
                      ? ListViewItem(
                          onTap: () {
                            setState(() {
                              setDarkTheme(!SharedPreferencesConstants.isDarkTheme);
                              SharedPreferencesConstants.isDarkTheme = !SharedPreferencesConstants.isDarkTheme;
                              themeProvider.toggleTheme();
                            });
                          },
                          title: getTranslated(context, ProfilePageKeys.darkTheme),
                          suffixWidget: SwitchComponent(
                              switchValue: SharedPreferencesConstants.isDarkTheme,
                              switchFunction: (value) {
                                setState(() {
                                  setDarkTheme(!SharedPreferencesConstants.isDarkTheme);
                                  SharedPreferencesConstants.isDarkTheme = !SharedPreferencesConstants.isDarkTheme;
                                  themeProvider.toggleTheme();
                                });
                              }),
                        )
                      : ListViewItem(title: "", isVisible: false),
                ],
              ),
            ),
          ));
    });
  }
}
