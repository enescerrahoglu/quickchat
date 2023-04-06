extension StringUtils on String {
  String camelcaseToKebabCase() {
    String value = "";
    for (var i = 0; i < length; i++) {
      if (i != 0 && this[i] == this[i].toUpperCase()) {
        value += "-";
      }
      value += this[i].toLowerCase();
    }

    return value;
  }
}
