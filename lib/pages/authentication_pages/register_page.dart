import 'package:quickchat/components/button_component.dart';
import 'package:quickchat/components/icon_component.dart';
import 'package:quickchat/components/text_component.dart';
import 'package:quickchat/components/text_form_field_component.dart';
import 'package:quickchat/constants/app_constants.dart';
import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/constants/string_constants.dart';
import 'package:quickchat/helpers/app_functions.dart';
import 'package:quickchat/localization/app_localization.dart';
import 'package:quickchat/routes/route_constants.dart';
import 'package:quickchat/widgets/base_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _confirmPasswordTextEditingController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      popScopeFunction: _isLoading ? () async => false : () async => true,
      title: getTranslated(context, LoginPageKeys.register),
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
                  Column(
                    children: [
                      TextFormFieldComponent(
                        context: context,
                        textEditingController: _emailTextEditingController,
                        focusNode: _focusNode1,
                        onSubmitted: (p0) => FocusScope.of(context).requestFocus(_focusNode2),
                        textInputAction: TextInputAction.next,
                        iconData: CustomIconData.at,
                        hintText: getTranslated(context, LoginPageKeys.email),
                        keyboardType: TextInputType.emailAddress,
                        validator: (emailText) {
                          bool emailValid = AppConstants.emailRegex.hasMatch(emailText!);
                          if (emailText.isEmpty || !emailValid) {
                            AppFunctions().showSnackbar(context, getTranslated(context, LoginPageKeys.emailVerificationMessage),
                                backgroundColor: warningDark, icon: CustomIconData.envelope);
                            return "";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormFieldComponent(
                        context: context,
                        textEditingController: _passwordTextEditingController,
                        focusNode: _focusNode2,
                        onSubmitted: (p0) => FocusScope.of(context).requestFocus(_focusNode3),
                        textInputAction: TextInputAction.next,
                        iconData: CustomIconData.lockKeyhole,
                        isPassword: true,
                        hintText: getTranslated(context, LoginPageKeys.password),
                        keyboardType: TextInputType.visiblePassword,
                        validator: (passwordText) {
                          bool passwordValid = AppConstants.passwordRegex.hasMatch(passwordText!);
                          if (passwordText.length < 8 || !passwordValid) {
                            if (AppConstants.emailRegex.hasMatch(_emailTextEditingController.text.trim().toLowerCase())) {
                              AppFunctions().showSnackbar(context, getTranslated(context, LoginPageKeys.passwordVerificationMessage),
                                  backgroundColor: warningDark, icon: CustomIconData.lockKeyhole, duration: 3);
                            }
                            return "";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormFieldComponent(
                        context: context,
                        textEditingController: _confirmPasswordTextEditingController,
                        focusNode: _focusNode3,
                        iconData: CustomIconData.lockKeyhole,
                        isPassword: true,
                        hintText: getTranslated(context, LoginPageKeys.confirmPassword),
                        keyboardType: TextInputType.visiblePassword,
                        validator: (passwordText) {
                          if (_confirmPasswordTextEditingController.text != _passwordTextEditingController.text) {
                            if ((_passwordTextEditingController.text.length >= 8) && AppConstants.passwordRegex.hasMatch(_passwordTextEditingController.text)) {
                              AppFunctions().showSnackbar(context, getTranslated(context, LoginPageKeys.passwordCheckMessage),
                                  backgroundColor: warningDark, icon: CustomIconData.lockKeyhole);
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
                        text: getTranslated(context, LoginPageKeys.register),
                        isWide: true,
                        isLoading: _isLoading,
                        onPressed: _isLoading
                            ? null
                            : () {
                                _register();
                              },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextComponent(text: getTranslated(context, LoginPageKeys.haveAnAccount), headerType: HeaderType.h6),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(context, loginPageRoute, (route) => false);
                          },
                          child: TextComponent(text: getTranslated(context, LoginPageKeys.logIn), headerType: HeaderType.h6, color: primaryColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _register() {
    if (_loginFormKey.currentState!.validate()) {
      debugPrint("true");
    } else {
      debugPrint("false");
    }
  }
}
