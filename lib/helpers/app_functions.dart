import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickchat/components/icon_component.dart';
import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/helpers/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickchat/models/user_model.dart';
import 'package:quickchat/services/user_service.dart';
import 'package:http/http.dart' as http;

class AppFunctions {
  UserService userService = UserService();

  void showSnackbar(BuildContext context, String text, {Color? backgroundColor, CustomIconData? icon, int duration = 2}) {
    final snackbar = SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Row(
        children: [
          icon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                  child: IconComponent(iconData: icon, size: 24, color: Colors.white),
                )
              : const SizedBox(),
          Expanded(child: Text(text, textAlign: icon != null ? TextAlign.start : TextAlign.center, style: const TextStyle(color: Colors.white))),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor != null ? backgroundColor.withOpacity(1) : Colors.grey.withOpacity(1),
      duration: Duration(seconds: duration),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackbar);
  }

  showProgressDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      context: context,
      builder: (context) {
        return WillPopScope(onWillPop: () async => false, child: alert);
      },
    );
  }

  void showMediaSnackbar(BuildContext context, Function cameraFunction, Function galleryFunction) {
    final snackbar = SnackBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              splashColor: lightPrimaryColor,
              iconSize: UIHelper.getDeviceWidth(context) / 8,
              onPressed: () {
                cameraFunction();
              },
              icon: IconComponent(
                iconData: CustomIconData.camera,
                color: Colors.white,
                size: UIHelper.getDeviceWidth(context) / 8,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              splashColor: lightPrimaryColor,
              iconSize: UIHelper.getDeviceWidth(context) / 8,
              onPressed: () {
                galleryFunction();
              },
              icon: IconComponent(
                iconData: CustomIconData.image,
                color: Colors.white,
                size: UIHelper.getDeviceWidth(context) / 8,
              ),
            ),
          )
        ],
      ),
      behavior: SnackBarBehavior.fixed,
      backgroundColor: primaryColor,
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackbar);
  }

  Future<File?> pickImageFromGallery() async {
    await Permission.storage.request();
    var permissionStatus = await Permission.storage.status;
    if (permissionStatus.isGranted) {
      try {
        final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 75, maxWidth: 1000);
        if (image == null) return null;
        final imageTemp = File(image.path);
        return imageTemp;
      } on PlatformException catch (e) {
        debugPrint('Failed to pick image: $e');
        return null;
      }
    } else {
      debugPrint('$permissionStatus');
      return null;
    }
  }

  Future<File?> pickImageFromCamera() async {
    await Permission.camera.request();
    var permissionStatus = await Permission.camera.status;
    if (permissionStatus.isGranted) {
      try {
        final image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 75, maxWidth: 1000);
        if (image == null) return null;
        final imageTemp = File(image.path);
        return imageTemp;
      } on PlatformException catch (e) {
        debugPrint('Failed to pick image: $e');
        return null;
      }
    } else {
      debugPrint('$permissionStatus');
      return null;
    }
  }

  Future<bool> sendVerificationCode(BuildContext context, String toMail, String code) async {
    try {
      await FirebaseFunctions.instance.httpsCallable('sendVerificationCode').call(<String, dynamic>{'to': toMail, 'code': code});
      debugPrint("sended");
      return true;
    } on FirebaseFunctionsException catch (error) {
      debugPrint(error.code);
      debugPrint(error.details);
      debugPrint(error.message);
      return false;
    }
  }

  int generateCode() {
    int randomCode = Random().nextInt(9000) + 1000;
    return randomCode;
  }

  void sendPushMessage(UserModel userModel, String title, String body) async {
    userModel = await userService.getUser(userModel.email);
    try {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAAOxqCFvU:APA91bFhN3eKEzJBv7EYBsROVk8Pgdyp-ooQIrSD07LuYW5NlCJJuC2iN3exodPXv2OAH4odTQX0qDKFAQTpX1bTTyIdJNdD8tc4OzqnBK2F0Ot6aj83DlWmxMjIDbybUCJOJCLEcQ_a'
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'title': title,
              'body': body,
            },
            'notification': <String, dynamic>{
              'android_channel_id': 'quickchat',
              'title': title,
              'body': body,
            },
            'to': userModel.notificationToken,
          }));
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error push notification!");
      }
    }
  }
}
