import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:quickchat/components/button_component.dart';
import 'package:quickchat/components/icon_component.dart';
import 'package:quickchat/components/text_component.dart';
import 'package:quickchat/constants/app_constants.dart';
import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/constants/string_constants.dart';
import 'package:quickchat/helpers/app_functions.dart';
import 'package:quickchat/helpers/ui_helper.dart';
import 'package:quickchat/localization/app_localization.dart';
import 'package:quickchat/models/user_model.dart';
import 'package:quickchat/providers/provider_container.dart';
import 'package:quickchat/providers/theme_provider.dart';
import 'package:quickchat/routes/route_constants.dart';
import 'package:quickchat/services/user_service.dart';
import 'package:quickchat/widgets/base_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;

class VerifyMailCodePage extends ConsumerStatefulWidget {
  const VerifyMailCodePage({Key? key}) : super(key: key);

  @override
  ConsumerState<VerifyMailCodePage> createState() => _VerifyMailCodePageState();
}

class _VerifyMailCodePageState extends ConsumerState<VerifyMailCodePage> {
  final TextEditingController _textEditingController1 = TextEditingController();
  final TextEditingController _textEditingController2 = TextEditingController();
  final TextEditingController _textEditingController3 = TextEditingController();
  final TextEditingController _textEditingController4 = TextEditingController();
  UserService userService = UserService();
  bool _isLoading = false;
  late int seconds;
  String enteredCode = "";
  UserModel? userModel;

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

  int verificationType = 0;

  late Timer timer;

  @override
  void initState() {
    super.initState();
    startTimer();
    userModel = ref.read(verificationUserProvider);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    verificationType = ModalRoute.of(context)!.settings.arguments as int;
    return BaseScaffoldWidget(
      popScopeFunction: _isLoading ? () async => false : showAysForCancelDialog,
      leadingWidget: IconButton(
        splashRadius: AppConstants.iconSplashRadius,
        icon: const IconComponent(iconData: CustomIconData.chevronLeft),
        onPressed: _isLoading ? () {} : showAysForCancelDialog,
      ),
      title: getTranslated(context, LoginPageKeys.verify),
      widgetList: [
        const Spacer(),
        TextComponent(
          text: getTranslated(context, LoginPageKeys.enterCode),
          headerType: HeaderType.h5,
        ),
        const SizedBox(height: 30),
        Form(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              getDigitField(1, themeProvider, _textEditingController1, _focusNode1),
              getDigitField(2, themeProvider, _textEditingController2, _focusNode2),
              getDigitField(3, themeProvider, _textEditingController3, _focusNode3),
              getDigitField(4, themeProvider, _textEditingController4, _focusNode4),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Container(
          decoration: BoxDecoration(color: infoDark.withOpacity(0.3), borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: IconComponent(
                    iconData: CustomIconData.circleInfo,
                    color: infoDark,
                  ),
                ),
                Expanded(
                  child: TextComponent(
                    textAlign: TextAlign.left,
                    text: getTranslated(context, LoginPageKeys.checkSpambox),
                    headerType: HeaderType.h6,
                    color: infoDark,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: ButtonComponent(
                text: seconds > 0 ? seconds.toString() : getTranslated(context, LoginPageKeys.resend),
                color: seconds > 0 ? warningDark : primaryColor,
                isOutLined: true,
                onPressed: seconds > 0
                    ? null
                    : () {
                        startTimer();
                        setState(() {
                          ref.watch(verificationCodeProvider.notifier).state = AppFunctions().generateCode();
                        });
                        AppFunctions().sendVerificationCode(context, userModel!.email, ref.watch(verificationCodeProvider).toString()).then((value) {
                          AppFunctions().showSnackbar(context, getTranslated(context, LoginPageKeys.codeSent),
                              icon: CustomIconData.paperPlane, backgroundColor: infoDark);
                          setState(() {
                            _isLoading = false;
                          });
                        });
                      },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ButtonComponent(
                text: getTranslated(context, LoginPageKeys.verify),
                isLoading: _isLoading,
                onPressed: () {
                  _verify();
                },
              ),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }

  _verify() {
    String digit1 = _textEditingController1.text;
    String digit2 = _textEditingController2.text;
    String digit3 = _textEditingController3.text;
    String digit4 = _textEditingController4.text;
    enteredCode = digit1 + digit2 + digit3 + digit4;
    debugPrint("code: $enteredCode");

    if (verificationType == 0) {
      if (userModel != null) {
        if (enteredCode == ref.watch(verificationCodeProvider).toString()) {
          AppFunctions()
              .showSnackbar(context, getTranslated(context, LoginPageKeys.profileCreating), backgroundColor: success, icon: CustomIconData.circleCheck);
          setState(() {
            _isLoading = true;
          });
          userService.register(userModel!).then((response) {
            if (response.isSucceeded) {
              userService.login(userModel!).then((value) {
                ref.read(loggedUserProvider.notifier).state = value.body;
                setState(() {
                  _isLoading = false;
                });
                userService.setLoggedUser(userModel!).then((response) {
                  if (response.isSucceeded) {
                    timer.cancel();
                    Navigator.pushNamedAndRemoveUntil(context, indicatorPageRoute, (route) => false);
                  }
                });
              });
            } else {
              timer.cancel();
              Navigator.pushNamedAndRemoveUntil(context, loginPageRoute, (route) => false);
            }
          });
        } else if (enteredCode.isEmpty) {
          AppFunctions()
              .showSnackbar(context, getTranslated(context, LoginPageKeys.enterCode), backgroundColor: warningDark, icon: CustomIconData.circleExclamation);
        } else {
          AppFunctions().showSnackbar(context, getTranslated(context, LoginPageKeys.checkCode), backgroundColor: dangerDark, icon: CustomIconData.circleXmark);
        }
      } else {
        timer.cancel();
        Navigator.pop(context);
      }
    } else if (verificationType == 1) {
      if (enteredCode == ref.watch(verificationCodeProvider).toString()) {
        timer.cancel();
        Navigator.pushReplacementNamed(context, updatePasswordPageRoute);
      } else if (enteredCode.isEmpty) {
        AppFunctions()
            .showSnackbar(context, getTranslated(context, LoginPageKeys.enterCode), backgroundColor: warningDark, icon: CustomIconData.circleExclamation);
      } else {
        AppFunctions().showSnackbar(context, getTranslated(context, LoginPageKeys.checkCode), backgroundColor: dangerDark, icon: CustomIconData.circleXmark);
      }
    } else {
      timer.cancel();
      Navigator.pop(context);
    }
  }

  getDigitField(int index, dynamic themeProvider, TextEditingController textEditingController, FocusNode focusNode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: SizedBox(
        width: UIHelper.getDeviceWidth(context) / 8,
        child: TextFormField(
          toolbarOptions: const ToolbarOptions(copy: false, cut: false, paste: false, selectAll: false),
          enableInteractiveSelection: false,
          showCursor: false,
          focusNode: focusNode,
          controller: textEditingController,
          onTap: () {
            textEditingController.selection = TextSelection.collapsed(offset: textEditingController.text.length);
          },
          onChanged: (value) {
            if (textEditingController.text.isNotEmpty) {
              if (index == 1) {
                FocusScope.of(context).requestFocus(_focusNode2);
              } else if (index == 2) {
                FocusScope.of(context).requestFocus(_focusNode3);
              } else if (index == 3) {
                FocusScope.of(context).requestFocus(_focusNode4);
              } else if (index == 4) {
                FocusScope.of(context).unfocus();
              }
            }
            if (textEditingController.text.isEmpty) {
              if (index == 4) {
                FocusScope.of(context).requestFocus(_focusNode3);
              } else if (index == 3) {
                FocusScope.of(context).requestFocus(_focusNode2);
              } else if (index == 2) {
                FocusScope.of(context).requestFocus(_focusNode1);
              }
            }
            setState(() {
              if (textEditingController.text.length > 1) {
                textEditingController.text = value.substring(value.length - 1);
              }
            });
          },
          cursorColor: primaryColor,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: primaryColor, width: 2)),
            filled: true,
            fillColor: (themeProvider.isDarkMode ? itemBackgroundDarkColor : itemBackgroundLightColor),
            contentPadding: const EdgeInsets.all(0),
          ),
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: primaryColor),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textAlign: TextAlign.center,
          keyboardType: const TextInputType.numberWithOptions(signed: true),
        ),
      ),
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

  startTimer() {
    seconds = 120;
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (cTimer) {
        seconds--;
        if (seconds == 0) {
          timer.cancel();
        }
      },
    );
  }
}
