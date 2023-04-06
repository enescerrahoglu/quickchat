import 'package:flutter/material.dart';
import 'package:quickchat/components/icon_component.dart';

class AppConstants {
  static final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static final RegExp passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
  static final RegExp usernameRegex = RegExp(r'^(?=[a-zA-Z0-9._]{3,20}$)(?!.*[_.]{2})[^_.].*[^_.]$');

  static BorderRadius borderRadius = BorderRadius.circular(10);

  static const double iconSplashRadius = 22;

  static CustomIconData? selectedNoteIcon;
}
