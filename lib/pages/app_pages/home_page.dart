import 'package:quickchat/components/circular_photo_component.dart';
import 'package:quickchat/components/icon_component.dart';
import 'package:quickchat/components/text_component.dart';
import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/constants/image_constants.dart';
import 'package:quickchat/constants/string_constants.dart';
import 'package:quickchat/helpers/ui_helper.dart';
import 'package:quickchat/localization/app_localization.dart';
import 'package:quickchat/models/user_model.dart';
import 'package:quickchat/providers/provider_container.dart';
import 'package:quickchat/providers/theme_provider.dart';
import 'package:quickchat/routes/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  UserModel? loggedUser;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    loggedUser = ref.read(loggedUserProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return provider.Consumer<ThemeProvider>(builder: (context, ThemeProvider themeProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: TextComponent(
            text: getTranslated(context, CommonKeys.homePage),
            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
          ),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(5),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                Navigator.pushNamed(context, profilePageRoute);
              },
              child: Align(
                child: SizedBox(
                  width: 35,
                  height: 35,
                  child: CircularPhotoComponent(
                    url: ref.watch(loggedUserProvider.notifier).state!.photoUrl ?? ImageAssetKeys.defaultProfilePhotoUrl,
                    smallCircularProgressIndicator: true,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(0),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconComponent(
                          iconData: CustomIconData.house,
                          color: primaryColor,
                          size: UIHelper.getDeviceWidth(context) / 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextComponent(text: getTranslated(context, CommonKeys.homePage), color: primaryColor, fontWeight: FontWeight.bold)
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: FloatingActionButton(
                    backgroundColor: primaryColor,
                    onPressed: () {},
                    splashColor: themeProvider.isDarkMode ? darkPrimaryColor : lightPrimaryColor,
                    child: const IconComponent(
                      iconData: CustomIconData.alarmClock,
                      iconWeight: CustomIconWeight.solid,
                      color: Colors.white,
                    )),
              )
            ],
          ),
        ),
      );
    });
  }
}
