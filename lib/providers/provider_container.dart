import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickchat/models/user_model.dart';
import 'package:quickchat/utils/enum_utils.dart';

final themeProvider = StateProvider<ThemeType>((ref) => ThemeType.light);
final loggedUserProvider = StateProvider<UserModel?>((ref) => null);
final targetUserProvider = StateProvider<UserModel?>((ref) => null);
final verificationCodeProvider = StateProvider<int?>((ref) => null);
final verificationUserProvider = StateProvider<UserModel?>((ref) => null);
