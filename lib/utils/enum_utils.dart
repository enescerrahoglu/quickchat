import 'package:flutter/foundation.dart';

extension EnumUtils on String {
  T? getEnumValue<T extends Enum>(List<T> enumValues) {
    for (T value in enumValues) {
      if (this == describeEnum(value)) return value;
    }
    return enumValues.first;
  }
}

enum ThemeType {
  light,
  dark,
}
