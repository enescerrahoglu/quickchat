import 'package:flutter/material.dart';
import 'package:quickchat/components/text_component.dart';
import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class AppSettingsDetailPage extends StatefulWidget {
  final String pageTitle;
  final Widget pageBody;
  const AppSettingsDetailPage({Key? key, required this.pageTitle, required this.pageBody}) : super(key: key);

  @override
  State<AppSettingsDetailPage> createState() => _AppSettingsDetailPageState();
}

class _AppSettingsDetailPageState extends State<AppSettingsDetailPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
          child: TextComponent(
            color: themeProvider.isDarkMode ? textPrimaryDarkColor : textPrimaryLightColor,
            text: widget.pageTitle,
            headerType: HeaderType.h4,
          ),
        ),
        Expanded(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: widget.pageBody,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
