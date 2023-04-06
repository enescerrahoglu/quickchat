import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/helpers/shared_preferences_helper.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme() {
    SharedPreferencesHelper.getBool("useDeviceTheme").then(
      (value) {
        if (value != null) {
          if (value) {
            themeMode = ThemeMode.system;
          } else {
            SharedPreferencesHelper.getBool("isDarkTheme").then(
              (value) {
                if (value != null) {
                  if (value) {
                    themeMode = ThemeMode.dark;
                  } else {
                    themeMode = ThemeMode.light;
                  }
                } else {
                  themeMode = ThemeMode.light;
                }
              },
            );
          }
        } else {
          themeMode = ThemeMode.system;
        }
        notifyListeners();
      },
    );
  }
}

class AppThemes {
  static final lightTheme = ThemeData(
    textTheme: const TextTheme(
      bodyText1: TextStyle(),
      bodyText2: TextStyle(),
    ).apply(bodyColor: Colors.black),
    scaffoldBackgroundColor: appBackgroundLightColor,
    backgroundColor: appBackgroundLightColor,
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: bottomSheetBackgroundLightColor),
    splashColor: itemDividerLightColor,
    dividerColor: itemDividerLightColor,
    radioTheme: RadioThemeData(fillColor: MaterialStateColor.resolveWith((states) => primaryColor)),
    appBarTheme: const AppBarTheme(
      elevation: 0.0,
      actionsIconTheme: IconThemeData(color: darkPrimaryColor),
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: darkPrimaryColor),
      toolbarTextStyle: TextStyle(color: darkPrimaryColor),
      titleTextStyle: TextStyle(color: darkPrimaryColor, fontSize: 18),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(circularTrackColor: indicatorBackgroundColor, color: indicatorLightColor),
  );

  static final darkTheme = ThemeData(
    textTheme: const TextTheme(
      bodyText1: TextStyle(),
      bodyText2: TextStyle(),
    ).apply(bodyColor: Colors.white),
    scaffoldBackgroundColor: appBackgroundDarkColor,
    backgroundColor: appBackgroundDarkColor,
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: bottomSheetBackgroundDarkColor),
    splashColor: itemDividerDarkColor,
    dividerColor: itemDividerDarkColor,
    radioTheme: RadioThemeData(fillColor: MaterialStateColor.resolveWith((states) => primaryColor)),
    appBarTheme: const AppBarTheme(
      elevation: 0.0,
      actionsIconTheme: IconThemeData(color: lightPrimaryColor),
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: lightPrimaryColor),
      toolbarTextStyle: TextStyle(color: lightPrimaryColor),
      titleTextStyle: TextStyle(color: lightPrimaryColor, fontSize: 18),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(circularTrackColor: indicatorBackgroundColor, color: indicatorDarkColor),
  );
}
