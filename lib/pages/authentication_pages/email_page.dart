import 'package:quickchat/components/button_component.dart';
import 'package:quickchat/components/icon_component.dart';
import 'package:quickchat/components/text_component.dart';
import 'package:quickchat/components/text_form_field_component.dart';
import 'package:quickchat/constants/app_constants.dart';
import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/constants/string_constants.dart';
import 'package:quickchat/helpers/app_functions.dart';
import 'package:quickchat/localization/app_localization.dart';
import 'package:quickchat/models/user_model.dart';
import 'package:quickchat/providers/provider_container.dart';
import 'package:quickchat/routes/route_constants.dart';
import 'package:quickchat/services/user_service.dart';
import 'package:quickchat/widgets/base_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailPage extends ConsumerStatefulWidget {
  const EmailPage({Key? key}) : super(key: key);

  @override
  ConsumerState<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends ConsumerState<EmailPage> {
  UserService userService = UserService();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String emailArg = "";

  @override
  void didChangeDependencies() {
    emailArg = ModalRoute.of(context)?.settings.arguments as String;
    _emailTextEditingController.text = emailArg;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
        popScopeFunction: _isLoading ? () async => false : () async => true,
        leadingWidget: IconButton(
          splashRadius: AppConstants.iconSplashRadius,
          icon: const IconComponent(iconData: CustomIconData.chevronLeft),
          onPressed: () => _isLoading ? null : Navigator.pop(context),
        ),
        title: getTranslated(context, LoginPageKeys.forgotPassword),
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
                    TextComponent(
                      text: getTranslated(context, LoginPageKeys.resetPassword),
                      headerType: HeaderType.h5,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormFieldComponent(
                      context: context,
                      textEditingController: _emailTextEditingController,
                      iconData: CustomIconData.at,
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
                    const SizedBox(
                      height: 20,
                    ),
                    ButtonComponent(
                      text: getTranslated(context, CommonKeys.send),
                      isWide: true,
                      isLoading: _isLoading,
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_loginFormKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                bool hasProfile = await userService.hasProfile(_emailTextEditingController.text);
                                debugPrint(_emailTextEditingController.text);
                                if (hasProfile) {
                                  ref.watch(verificationCodeProvider.notifier).state = AppFunctions().generateCode();

                                  if (mounted) {}
                                  AppFunctions()
                                      .sendVerificationCode(
                                          context, _emailTextEditingController.text.replaceAll(" ", ""), ref.watch(verificationCodeProvider).toString())
                                      .then((value) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    AppFunctions().showSnackbar(context, getTranslated(context, LoginPageKeys.codeSent),
                                        icon: CustomIconData.paperPlane, backgroundColor: infoDark);
                                    ref.watch(verificationUserProvider.notifier).state = UserModel(email: _emailTextEditingController.text, password: "");
                                    Navigator.pushNamed(context, verifyMailCodePageRoute, arguments: 1);
                                  });
                                } else {
                                  setState(() {
                                    _isLoading = false;
                                  });

                                  if (mounted) {
                                    AppFunctions().showSnackbar(context, getTranslated(context, LoginPageKeys.nonExistingUser),
                                        icon: CustomIconData.userSlash, backgroundColor: dangerDark);
                                  }
                                }
                              }
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
          ),
        ]);
  }
}
