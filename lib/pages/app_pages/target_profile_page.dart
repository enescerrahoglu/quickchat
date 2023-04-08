import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:quickchat/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickchat/components/text_component.dart';
import 'package:quickchat/components/circular_photo_component.dart';
import 'package:quickchat/components/icon_component.dart';
import 'package:quickchat/components/list_view_component.dart';
import 'package:quickchat/constants/app_constants.dart';
import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/constants/string_constants.dart';
import 'package:quickchat/helpers/ui_helper.dart';
import 'package:quickchat/localization/app_localization.dart';
import 'package:quickchat/providers/provider_container.dart';
import 'package:quickchat/providers/theme_provider.dart';
import 'package:quickchat/services/user_service.dart';
import 'package:quickchat/widgets/base_scaffold_widget.dart';
import 'package:quickchat/widgets/marquee_widget.dart';
import 'package:provider/provider.dart' as provider;

class TargetProfilePage extends ConsumerStatefulWidget {
  const TargetProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TargetProfilePageState();
}

class _TargetProfilePageState extends ConsumerState<TargetProfilePage> {
  UserService userService = UserService();
  UserModel? loggedUser;
  UserModel? targetUser;
  bool _showPreview = false;

  @override
  void initState() {
    loggedUser = ref.read(loggedUserProvider);
    targetUser = ref.read(targetUserProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    return Stack(
      children: [
        BaseScaffoldWidget(
          title: getTranslated(context, CommonKeys.profile),
          leadingWidget: IconButton(
            splashRadius: AppConstants.iconSplashRadius,
            icon: const IconComponent(iconData: CustomIconData.chevronLeft),
            onPressed: () => Navigator.pop(context),
          ),
          widgetList: [
            Container(
              decoration: BoxDecoration(
                color: themeProvider.isDarkMode ? itemBackgroundDarkColor : itemBackgroundLightColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      GestureDetector(
                        onLongPress: () {
                          HapticFeedback.vibrate();
                          setState(() {
                            _showPreview = true;
                          });
                        },
                        onLongPressEnd: (details) {
                          HapticFeedback.vibrate();
                          setState(() {
                            _showPreview = false;
                          });
                        },
                        child: SizedBox(
                          height: UIHelper.isDevicePortrait(context) ? UIHelper.getDeviceWidth(context) / 2.5 : UIHelper.getDeviceHeight(context) / 2,
                          width: UIHelper.isDevicePortrait(context) ? UIHelper.getDeviceWidth(context) / 2.5 : UIHelper.getDeviceHeight(context) / 2,
                          child: CircularPhotoComponent(
                            url: targetUser!.photoUrl,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      MarqueeWidget(
                        child: TextComponent(
                          text: "${targetUser!.firstName} ${targetUser!.lastName}",
                          headerType: HeaderType.h4,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextComponent(
                        text: "${getTranslated(context, CommonKeys.joinDate)} ${DateFormat('dd.MM.yyyy').format(DateTime.parse(targetUser!.createdDate!))}",
                        headerType: HeaderType.h8,
                        color: themeProvider.isDarkMode ? itemDividerLightColor : itemDividerDarkColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            ListViewComponent(
              itemList: [
                generateListViewItem(targetUser!.email, CustomIconData.at, hasSuffix: false),
                generateListViewItem(targetUser!.userName, CustomIconData.user, hasSuffix: false),
              ],
            ),
          ],
        ),
        if (_showPreview) ...[
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 5.0,
            ),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Center(
            child: SizedBox(
              height: UIHelper.isDevicePortrait(context) ? UIHelper.getDeviceWidth(context) : UIHelper.getDeviceHeight(context) / 1.25,
              width: UIHelper.isDevicePortrait(context) ? UIHelper.getDeviceWidth(context) : UIHelper.getDeviceHeight(context) / 1.25,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: CircularPhotoComponent(
                  url: targetUser!.photoUrl,
                ),
              ),
            ),
          ),
        ]
      ],
    );
  }

  ListViewItem generateListViewItem(String title, CustomIconData prefixIcon,
      {Widget? settingPage, Function? onTap, ThemeProvider? themeProvider, bool hasSuffix = true}) {
    return ListViewItem(
      title: getTranslated(context, title),
      prefixWidget: IconComponent(iconData: prefixIcon),
      suffixWidget: hasSuffix
          ? IconComponent(
              iconData: CustomIconData.angleRight,
              color: themeProvider == null ? Colors.grey : (themeProvider.isDarkMode ? itemDividerDarkColor : itemDividerLightColor))
          : null,
      onTap: null,
    );
  }
}
