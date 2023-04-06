import 'package:quickchat/components/icon_component.dart';

class PopupMenuWidgetItem {
  String title;
  Function function;
  String? subTitle;
  CustomIconData? prefixIcon;
  CustomIconData? suffixIcon;

  PopupMenuWidgetItem({
    required this.title,
    required this.function,
    this.subTitle,
    this.prefixIcon,
    this.suffixIcon,
  });
}
