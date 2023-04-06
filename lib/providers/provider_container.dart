import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickchat/utils/enum_utils.dart';

final themeProvider = StateProvider<ThemeType>((ref) => ThemeType.light);
