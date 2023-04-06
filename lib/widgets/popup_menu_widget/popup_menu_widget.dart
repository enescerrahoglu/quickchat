import 'package:quickchat/components/icon_component.dart';
import 'package:quickchat/components/text_component.dart';
import 'package:quickchat/constants/app_constants.dart';
import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/providers/theme_provider.dart';
import 'package:quickchat/widgets/popup_menu_widget/popup_menu_widget_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopupMenuWidget extends StatelessWidget {
  final List<List<PopupMenuWidgetItem>> menuList;
  final CustomIconData iconData;

  const PopupMenuWidget({Key? key, required this.menuList, this.iconData = CustomIconData.ellipsisVertical}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    List<PopupMenuEntry> popupMenuEntryList = [];

    int counter = 0;
    for (List<PopupMenuWidgetItem> list in menuList) {
      for (PopupMenuWidgetItem listItem in list) {
        popupMenuEntryList.add(PopupMenuItem(
          onTap: () {
            listItem.function();
          },
          child:
              createPopupMenuItemWidget(listItem.title, listItem.subTitle, listItem.prefixIcon, listItem.suffixIcon, listItem.function, context, themeProvider),
        ));
      }

      if (counter != menuList.length - 1) {
        popupMenuEntryList.add(const PopupMenuDivider());
      }
      counter++;
    }

    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: themeProvider.isDarkMode ? Colors.white : Colors.black),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black),
          bodyText2: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black),
        ).apply(bodyColor: themeProvider.isDarkMode ? Colors.white : Colors.black),
      ),
      child: TooltipVisibility(
        visible: false,
        child: PopupMenuButton(
          icon: IconComponent(iconData: iconData),
          splashRadius: AppConstants.iconSplashRadius,
          padding: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          offset: const Offset(0, 0),
          itemBuilder: ((context) => popupMenuEntryList),
          color: themeProvider.isDarkMode ? itemBackgroundDarkColor.withOpacity(1) : itemBackgroundLightColor.withOpacity(1),
        ),
      ),
    );
  }

  createPopupMenuItemWidget(String title, String? subTitle, CustomIconData? prefixIcon, CustomIconData? suffixIcon, Function function, BuildContext context,
      ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        prefixIcon != null
            ? IconComponent(
                iconData: prefixIcon,
                color: themeProvider.isDarkMode ? Colors.white : Colors.black,
              )
            : const SizedBox(),
        Flexible(
          fit: FlexFit.tight,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextComponent(
                  text: title,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  maxLines: 1,
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                ),
                Visibility(
                  visible: (subTitle != null && subTitle.isNotEmpty),
                  child: TextComponent(
                    text: subTitle ?? "",
                    headerType: HeaderType.h6,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
        suffixIcon != null
            ? IconComponent(
                iconData: suffixIcon,
              )
            : const SizedBox()
      ],
    );
  }
}
