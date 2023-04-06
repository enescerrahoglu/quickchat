import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/helpers/ui_helper.dart';
import 'package:provider/provider.dart' as provider;
import 'package:quickchat/providers/theme_provider.dart';

class LazyMessageBubble extends ConsumerStatefulWidget {
  const LazyMessageBubble({super.key});

  @override
  ConsumerState<LazyMessageBubble> createState() => _LazyMessageBubbleState();
}

class _LazyMessageBubbleState extends ConsumerState<LazyMessageBubble> {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = provider.Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
              color: (themeProvider.isDarkMode ? itemBackgroundDarkColor : itemBackgroundLightColor),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10), topRight: Radius.circular(3)),
            ),
            width: UIHelper.getDeviceWidth(context) / 1.25,
            height: 50,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
              color: (themeProvider.isDarkMode ? itemBackgroundDarkColor : itemBackgroundLightColor),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(3), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            width: UIHelper.getDeviceWidth(context) / 1.25,
            height: 75,
          ),
        ),
      ],
    );
  }
}
