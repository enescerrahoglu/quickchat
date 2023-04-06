import 'package:flutter/cupertino.dart';
import 'package:quickchat/components/button_component.dart';
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
import 'package:quickchat/providers/theme_provider.dart';
import 'package:quickchat/routes/route_constants.dart';
import 'package:quickchat/widgets/base_scaffold_widget.dart';
import 'package:quickchat/widgets/modal_bottom_sheet_widget.dart';
import 'package:provider/provider.dart' as provider;

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
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
                        child: SizedBox(
                          height: UIHelper.isDevicePortrait(context) ? UIHelper.getDeviceWidth(context) / 2.5 : UIHelper.getDeviceHeight(context) / 2,
                          width: UIHelper.isDevicePortrait(context) ? UIHelper.getDeviceWidth(context) / 2.5 : UIHelper.getDeviceHeight(context) / 2,
                          child: const CircularPhotoComponent(
                            url: "https://logowik.com/content/uploads/images/flutter5786.jpg",
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const TextComponent(
                        text: "Name Surname",
                        headerType: HeaderType.h4,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                      const SizedBox(height: 20),
                      ButtonComponent(
                        isOutLined: true,
                        text: getTranslated(context, UpdateProfilePageKeys.updateProfile),
                        onPressed: () {
                          Navigator.pushNamed(context, updateProfilePageRoute);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            ListViewComponent(
              itemList: [
                generateListViewItem("email@gmail.com", CustomIconData.at, hasSuffix: false),
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
                              Navigator.pushNamedAndRemoveUntil(context, loginPageRoute, (route) => false);
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
