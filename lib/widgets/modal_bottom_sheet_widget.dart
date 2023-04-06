import 'package:flutter/material.dart';
import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/helpers/ui_helper.dart';
import 'package:quickchat/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ModalBottomSheetWidget {
  getShowModalBottomSheetWidget(BuildContext context, Widget widget) {
    return showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      isScrollControlled: false,
      context: context,
      builder: (BuildContext context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: themeProvider.isDarkMode ? textPrimaryDarkColor : textPrimaryLightColor,
                ),
                height: 5,
                width: UIHelper.getDeviceWidth(context) / 4,
              ),
            ),
            Expanded(child: widget),
          ],
        );
      },
    );
  }
}
