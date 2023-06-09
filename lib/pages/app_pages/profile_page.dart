import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:quickchat/models/user_model.dart';
import 'package:quickchat/pages/settings_pages/app_settings_detail_page.dart';
import 'package:quickchat/pages/settings_pages/settings_bottom_sheet_dialog_pages/language_settings_page.dart';
import 'package:quickchat/pages/settings_pages/settings_bottom_sheet_dialog_pages/theme_settings_page.dart';
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
import 'package:quickchat/routes/route_constants.dart';
import 'package:quickchat/services/user_service.dart';
import 'package:quickchat/widgets/base_scaffold_widget.dart';
import 'package:quickchat/widgets/marquee_widget.dart';
import 'package:quickchat/widgets/modal_bottom_sheet_widget.dart';
import 'package:provider/provider.dart' as provider;

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  UserService userService = UserService();
  UserModel? loggedUser;
  bool _showPreview = false;

  @override
  void initState() {
    loggedUser = ref.read(loggedUserProvider);
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
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, updateProfilePageRoute);
                        },
                        icon: const IconComponent(
                          iconData: CustomIconData.pen,
                          color: primaryColor,
                        ),
                        splashRadius: AppConstants.iconSplashRadius,
                      ),
                    ),
                  ),
                  Padding(
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
                              child: Hero(
                                tag: loggedUser!.email,
                                child: CircularPhotoComponent(
                                  url: loggedUser!.photoUrl,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          MarqueeWidget(
                            child: TextComponent(
                              text: "${loggedUser!.firstName} ${loggedUser!.lastName}",
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
                            text:
                                "${getTranslated(context, ProfilePageKeys.joined1)}${DateFormat('dd.MM.yyyy').format(DateTime.parse(loggedUser!.createdDate!))}${getTranslated(context, ProfilePageKeys.joined2)}",
                            headerType: HeaderType.h8,
                            color: themeProvider.isDarkMode ? itemDividerLightColor : itemDividerDarkColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            ListViewComponent(
              itemList: [
                generateListViewItem(loggedUser!.email, CustomIconData.at, hasSuffix: false),
                generateListViewItem(loggedUser!.userName, CustomIconData.user, hasSuffix: false),
              ],
            ),
            ListViewComponent(
              itemList: [
                generateListViewItem(getTranslated(context, CommonKeys.theme), CustomIconData.palette,
                    settingPage: const ThemeSettingsPage(), themeProvider: themeProvider),
                generateListViewItem(getTranslated(context, CommonKeys.language), CustomIconData.globe,
                    settingPage: const LanguageSettingsPage(), themeProvider: themeProvider),
                generateListViewItem(
                  getTranslated(context, ProfilePageKeys.logOut),
                  CustomIconData.arrowRightFromBracket,
                  themeProvider: themeProvider,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog(
                        content: TextComponent(text: getTranslated(context, ProfilePageKeys.aysLogOut), textAlign: TextAlign.start, headerType: HeaderType.h5),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            child: Text(getTranslated(context, CommonKeys.yes)),
                            onPressed: () {
                              userService.logout(context);
                            },
                          ),
                          CupertinoDialogAction(
                            child: Text(getTranslated(context, CommonKeys.no)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
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
                  url: loggedUser!.photoUrl,
                ),
              ),
            ),
          ),
        ]
      ],
    );
  }

  showSettingsModalBottomSheet(BuildContext buildContext, String pageTitle, Widget pageBody) {
    ModalBottomSheetWidget().getShowModalBottomSheetWidget(
      buildContext,
      AppSettingsDetailPage(
        pageTitle: pageTitle,
        pageBody: pageBody,
      ),
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
      onTap: onTap ??
          (settingPage != null
              ? () {
                  showSettingsModalBottomSheet(context, getTranslated(context, title), settingPage);
                }
              : null),
    );
  }
}
