import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/constants/image_constants.dart';
import 'package:quickchat/helpers/shared_preferences_helper.dart';
import 'package:quickchat/helpers/ui_helper.dart';
import 'package:quickchat/models/user_model.dart';
import 'package:quickchat/providers/provider_container.dart';
import 'package:quickchat/routes/route_constants.dart';
import 'package:quickchat/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickchat/widgets/base_scaffold_widget.dart';

class IndicatorPage extends ConsumerStatefulWidget {
  const IndicatorPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IndicatorPageState();
}

class _IndicatorPageState extends ConsumerState<IndicatorPage> {
  UserModel? loggedUser;
  UserService userService = UserService();

  Future<String?> getFutureFromSP() async {
    String? loggedUser = await SharedPreferencesHelper.getString("loggedUser");
    return loggedUser;
  }

  Future<void> getFuture() async {
    getFutureFromSP().then((loggedUserSP) {
      if (loggedUserSP != null && loggedUserSP.toString().isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(loggedUserProvider.notifier).state = UserModel.fromJson(jsonDecode(loggedUserSP.toString()));
          loggedUser = ref.read(loggedUserProvider);
          userService.hasProfile(loggedUser!.email).then((value) {
            if (value) {
              debugPrint("profil var. value: $value");
              userService.getUser(loggedUser!.email).then((model) async {
                String? token = await getToken();
                debugPrint('user token: $token');
                userService.updateNotificationToken(model, token ?? '');

                ref.watch(loggedUserProvider.notifier).state = model;

                userService.userInfoFull(loggedUser!.email).then((value) async {
                  if (value) {
                    Navigator.pushNamedAndRemoveUntil(context, homePageRoute, (route) => false);
                  } else {
                    Navigator.pushNamedAndRemoveUntil(context, updateProfilePageRoute, (route) => false, arguments: 1);
                  }
                });
              });
            } else {
              debugPrint("profil yok! value: $value");
              userService.logout(context);
            }
          });
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamedAndRemoveUntil(context, loginPageRoute, (route) => false);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getFuture(),
      builder: (context, snapshot) {
        return WillPopScope(
          onWillPop: () async => false,
          child: BaseScaffoldWidget(
            hasAppBar: false,
            widgetList: [
              const Spacer(),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: primaryColor,
                    child: Image.asset(
                      ImageAssetKeys.indicator,
                      width: UIHelper.isDevicePortrait(context) ? UIHelper.getDeviceWidth(context) / 4 : UIHelper.getDeviceHeight(context) / 4,
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }

  Future<String?> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token;
  }
}
