import 'package:flutter/material.dart';
import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class UIHelper {
  createItemListContainer(List<Widget> widgetList, BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode ? itemBackgroundDarkColor : itemBackgroundLightColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widgetList,
        ),
      ),
    );
  }

  drawDivider() {
    return const Divider(
      thickness: 1,
    );
  }

  static isDevicePortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait ? true : false;
  }

  static double getButtonBottomPadding(BuildContext context) {
    return MediaQuery.of(context).size.height / 20;
  }

  static double getDeviceHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getDeviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
