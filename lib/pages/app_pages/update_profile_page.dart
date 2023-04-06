import 'dart:io';
import 'package:quickchat/components/button_component.dart';
import 'package:quickchat/components/circular_photo_component.dart';
import 'package:quickchat/components/icon_component.dart';
import 'package:quickchat/components/text_component.dart';
import 'package:quickchat/components/text_form_field_component.dart';
import 'package:quickchat/constants/app_constants.dart';
import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/constants/string_constants.dart';
import 'package:quickchat/helpers/app_functions.dart';
import 'package:quickchat/helpers/ui_helper.dart';
import 'package:quickchat/localization/app_localization.dart';
import 'package:quickchat/widgets/base_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateProfilePage extends ConsumerStatefulWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends ConsumerState<UpdateProfilePage> {
  File? pickedImage;
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController firstNameEditingController = TextEditingController();
  TextEditingController lastNameEditingController = TextEditingController();
  bool isLoading = false;
  final _loginFormKey = GlobalKey<FormState>();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    pickedImage = null;
    emailEditingController.text = "email@gmail.com";
    firstNameEditingController.text = "Name";
    lastNameEditingController.text = "Surname";
  }

  @override
  Widget build(BuildContext context) {
    int? arg = ModalRoute.of(context)!.settings.arguments as int?;
    debugPrint("arg: $arg");
    return BaseScaffoldWidget(
      key: _scaffoldKey,
      popScopeFunction: isLoading ? () async => false : () async => true,
      title: getTranslated(context, arg == 1 ? UpdateProfilePageKeys.completeTheProfile : UpdateProfilePageKeys.updateProfile),
      leadingWidget: arg == 1
          ? null
          : IconButton(
              splashRadius: AppConstants.iconSplashRadius,
              icon: const IconComponent(iconData: CustomIconData.chevronLeft),
              onPressed: () => isLoading ? null : Navigator.pop(context),
            ),
      widgetList: [
        Align(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: SizedBox(
              height: UIHelper.isDevicePortrait(context) ? UIHelper.getDeviceWidth(context) / 2.5 : UIHelper.getDeviceHeight(context) / 2,
              width: UIHelper.isDevicePortrait(context) ? UIHelper.getDeviceWidth(context) / 2.5 : UIHelper.getDeviceHeight(context) / 2,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  AppFunctions().showMediaSnackbar(context, () {
                    AppFunctions().pickImageFromCamera().then((file) {
                      setState(() => pickedImage = file);
                    });
                  }, () {
                    AppFunctions().pickImageFromGallery().then((file) {
                      setState(() => pickedImage = file);
                    });
                  });
                },
                child: pickedImage == null
                    ? const CircularPhotoComponent(
                        url: "https://logowik.com/content/uploads/images/flutter5786.jpg",
                      )
                    : CircularPhotoComponent(
                        image: pickedImage,
                      ),
              ),
            ),
          ),
        ),
        Form(
          key: _loginFormKey,
          child: Column(
            children: [
              TextFormFieldComponent(
                context: context,
                textEditingController: emailEditingController,
                hintText: getTranslated(context, LoginPageKeys.email),
                readOnly: true,
                iconData: CustomIconData.envelope,
                validator: (emailText) {
                  if (emailText!.isEmpty) {
                    AppFunctions().showSnackbar(context, getTranslated(context, UpdateProfilePageKeys.enterFirstName),
                        backgroundColor: warningDark, icon: CustomIconData.featherPointed);
                    return "";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 3),
                  child: TextComponent(
                    text: getTranslated(context, UpdateProfilePageKeys.firstName),
                    headerType: HeaderType.h8,
                    color: primaryColor,
                  ),
                ),
              ),
              TextFormFieldComponent(
                context: context,
                textEditingController: firstNameEditingController,
                textCapitalization: TextCapitalization.words,
                enabled: !isLoading,
                focusNode: _focusNode1,
                onSubmitted: (p0) => FocusScope.of(context).requestFocus(_focusNode2),
                textInputAction: TextInputAction.next,
                hintText: getTranslated(context, UpdateProfilePageKeys.firstName),
                maxCharacter: 20,
                validator: (firstNameText) {
                  if (firstNameText!.trim().isEmpty) {
                    AppFunctions().showSnackbar(context, getTranslated(context, UpdateProfilePageKeys.enterFirstName),
                        backgroundColor: warningDark, icon: CustomIconData.featherPointed);
                    return "";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 3),
                  child: TextComponent(
                    text: getTranslated(context, UpdateProfilePageKeys.lastName),
                    headerType: HeaderType.h8,
                    color: primaryColor,
                  ),
                ),
              ),
              TextFormFieldComponent(
                context: context,
                textEditingController: lastNameEditingController,
                enabled: !isLoading,
                textCapitalization: TextCapitalization.words,
                focusNode: _focusNode2,
                textInputAction: TextInputAction.next,
                hintText: getTranslated(context, UpdateProfilePageKeys.lastName),
                maxCharacter: 20,
                validator: (lastNameText) {
                  if (firstNameEditingController.text.trim().isNotEmpty) {
                    if (lastNameText!.trim().isEmpty) {
                      AppFunctions().showSnackbar(context, getTranslated(context, UpdateProfilePageKeys.enterLastname),
                          backgroundColor: warningDark, icon: CustomIconData.featherPointed);
                      return "";
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 3),
                  child: TextComponent(
                    text: getTranslated(context, UpdateProfilePageKeys.userName),
                    headerType: HeaderType.h8,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        const SizedBox(height: 20),
        ButtonComponent(
          text: getTranslated(context, arg == 1 ? CommonKeys.finishIt : CommonKeys.update),
          isWide: true,
          isLoading: isLoading,
          onPressed: isLoading ? null : () {},
        ),
      ],
    );
  }
}
