import 'package:flutter/cupertino.dart';
import 'package:quickchat/components/button_component.dart';
import 'package:quickchat/components/icon_component.dart';
import 'package:quickchat/components/text_component.dart';
import 'package:quickchat/components/text_form_field_component.dart';
import 'package:quickchat/constants/app_constants.dart';
import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/constants/string_constants.dart';
import 'package:quickchat/helpers/app_functions.dart';
import 'package:quickchat/localization/app_localization.dart';
import 'package:quickchat/widgets/base_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdatePasswordPage extends ConsumerStatefulWidget {
  const UpdatePasswordPage({Key? key}) : super(key: key);

  @override
  ConsumerState<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends ConsumerState<UpdatePasswordPage> {
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _confirmPasswordTextEditingController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      popScopeFunction: _isLoading ? () async => false : showAysForCancelDialog,
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft),
        onPressed: _isLoading ? null : showAysForCancelDialog,
      ),
      title: getTranslated(context, CommonKeys.update),
      widgetList: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  TextFormFieldComponent(
                    context: context,
                    textEditingController: _emailTextEditingController,
                    iconData: CustomIconData.at,
                    enabled: false,
                    hintText: getTranslated(context, LoginPageKeys.email),
                    keyboardType: TextInputType.emailAddress,
                    validator: (emailText) {
                      bool emailValid = AppConstants.emailRegex.hasMatch(emailText!);
                      if (emailText.isEmpty || !emailValid) {
                        AppFunctions().showSnackbar(context, getTranslated(context, LoginPageKeys.emailVerificationMessage),
                            backgroundColor: dangerDark, icon: CustomIconData.envelope);
                        return "";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormFieldComponent(
                    context: context,
                    textEditingController: _passwordTextEditingController,
                    focusNode: _focusNode1,
                    onSubmitted: (p0) => FocusScope.of(context).requestFocus(_focusNode2),
                    textInputAction: TextInputAction.next,
                    iconData: CustomIconData.lockKeyhole,
                    isPassword: true,
                    hintText: getTranslated(context, LoginPageKeys.password),
                    keyboardType: TextInputType.visiblePassword,
                    validator: (passwordText) {
                      bool passwordValid = AppConstants.passwordRegex.hasMatch(passwordText!);
                      if (passwordText.length < 8 || !passwordValid) {
                        AppFunctions().showSnackbar(context, getTranslated(context, LoginPageKeys.passwordVerificationMessage),
                            backgroundColor: dangerDark, icon: CustomIconData.lockKeyhole);
                        return "";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormFieldComponent(
                    context: context,
                    textEditingController: _confirmPasswordTextEditingController,
                    focusNode: _focusNode2,
                    iconData: CustomIconData.lockKeyhole,
                    isPassword: true,
                    hintText: getTranslated(context, LoginPageKeys.confirmPassword),
                    keyboardType: TextInputType.visiblePassword,
                    validator: (passwordText) {
                      if (_confirmPasswordTextEditingController.text != _passwordTextEditingController.text) {
                        if ((_passwordTextEditingController.text.length >= 8) && AppConstants.passwordRegex.hasMatch(_passwordTextEditingController.text)) {
                          AppFunctions().showSnackbar(context, getTranslated(context, LoginPageKeys.passwordCheckMessage),
                              backgroundColor: dangerDark, icon: CustomIconData.lockKeyhole);
                        }
                        return "";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonComponent(
                    text: getTranslated(context, CommonKeys.update),
                    isWide: true,
                    isLoading: _isLoading,
                    onPressed: _isLoading
                        ? null
                        : () {
                            _update();
                          },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  showAysForCancelDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(getTranslated(context, CommonKeys.processContinues), textAlign: TextAlign.start),
        content: TextComponent(text: getTranslated(context, CommonKeys.aysForCancel), textAlign: TextAlign.start, headerType: HeaderType.h6),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(getTranslated(context, CommonKeys.yes)),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
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
  }

  _update() {
    if (_loginFormKey.currentState!.validate()) {
    } else {
      debugPrint("false");
    }
  }
}
