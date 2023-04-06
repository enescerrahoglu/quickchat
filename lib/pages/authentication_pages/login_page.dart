import 'package:quickchat/components/button_component.dart';
import 'package:quickchat/components/icon_component.dart';
import 'package:quickchat/components/text_component.dart';
import 'package:quickchat/components/text_form_field_component.dart';
import 'package:quickchat/constants/app_constants.dart';
import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/constants/string_constants.dart';
import 'package:quickchat/helpers/app_functions.dart';
import 'package:quickchat/helpers/shared_preferences_helper.dart';
import 'package:quickchat/localization/app_localization.dart';
import 'package:quickchat/routes/route_constants.dart';
import 'package:quickchat/widgets/base_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  @override
  void initState() {
    super.initState();

    SharedPreferencesHelper.getString("loggedUser").then((value) {
      if (value != null) {
        Navigator.pushNamedAndRemoveUntil(context, navigationPageRoute, (route) => false);
      } else {
        debugPrint("null sp user");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      popScopeFunction: _isLoading ? () async => false : () async => true,
      title: getTranslated(context, LoginPageKeys.logIn),
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
                        iconData: CustomIconData.at,
                        focusNode: _focusNode1,
                        onSubmitted: (p0) => FocusScope.of(context).requestFocus(_focusNode2),
                        textInputAction: TextInputAction.next,
                        hintText: getTranslated(context, LoginPageKeys.email),
                        keyboardType: TextInputType.emailAddress,
                        validator: (emailText) {
                          bool emailValid = AppConstants.emailRegex.hasMatch(emailText!.trim().toLowerCase());
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
                        iconData: CustomIconData.lockKeyhole,
                        isPassword: true,
                        focusNode: _focusNode2,
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
                        height: 20,
                      ),
                      ButtonComponent(
                        text: getTranslated(context, LoginPageKeys.logIn),
                        isWide: true,
                        isLoading: _isLoading,
                        onPressed: _isLoading
                            ? null
                            : () {
                                _login();
                              },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, emailPageRoute, arguments: _emailTextEditingController.text.trim().toLowerCase());
                        },
                        child: TextComponent(
                          text: getTranslated(context, LoginPageKeys.forgotPassword),
                          headerType: HeaderType.h6,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(height: 20),
                        TextComponent(text: getTranslated(context, LoginPageKeys.doNotYouHaveAnAccountYet), headerType: HeaderType.h6),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(context, registerPageRoute, (route) => false);
                          },
                          child: TextComponent(
                            text: getTranslated(context, LoginPageKeys.register),
                            headerType: HeaderType.h6,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _login() {
    if (_loginFormKey.currentState!.validate()) {
      debugPrint("true");
    } else {
      debugPrint("false");
    }
  }
}
