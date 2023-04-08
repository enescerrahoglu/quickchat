import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickchat/components/circular_photo_component.dart';
import 'package:quickchat/components/icon_component.dart';
import 'package:quickchat/components/marquee_text_component.dart';
import 'package:quickchat/components/rectangle_photo_component.dart';
import 'package:quickchat/components/text_component.dart';
import 'package:quickchat/constants/app_constants.dart';
import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/constants/image_constants.dart';
import 'package:quickchat/helpers/app_functions.dart';
import 'package:quickchat/helpers/ui_helper.dart';
import 'package:quickchat/models/message_model.dart';
import 'package:quickchat/models/user_model.dart';
import 'package:quickchat/providers/provider_container.dart';
import 'package:quickchat/providers/theme_provider.dart';
import 'package:quickchat/routes/route_constants.dart';
import 'package:quickchat/services/user_service.dart';
import 'package:provider/provider.dart' as provider;
import 'package:quickchat/widgets/message_bubble.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  UserService userService = UserService();
  TextEditingController chatTextEditingController = TextEditingController();
  bool _isLoading = false;
  bool isPageLoading = false;

  UserModel? loggedUser;
  UserModel? targetUser;
  File? _pickedImage;

  List<MessageModel> messages = [];

  @override
  void dispose() {
    chatTextEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    loggedUser = ref.read(loggedUserProvider);
    targetUser = ref.read(targetUserProvider);
    Future.delayed(Duration.zero, () async {
      setState(() {
        isPageLoading = true;
      });
      messages = await userService.getMessages(loggedUser!, targetUser!);
      setState(() {
        isPageLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    return WillPopScope(
      onWillPop: _isLoading ? () async => false : () async => true,
      child: Scaffold(
        appBar: AppBar(
          title: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              ref.watch(targetUserProvider.notifier).state = targetUser;
              if (targetUser!.email == loggedUser!.email) {
                Navigator.pushNamed(context, profilePageRoute);
              } else {
                Navigator.pushNamed(context, targetProfilePageRoute);
              }
            },
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: CircularPhotoComponent(
                      url: targetUser!.photoUrl,
                      smallCircularProgressIndicator: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: MarqueeTextComponent(
                    text: "${targetUser!.firstName} ${targetUser!.lastName}",
                    color: themeProvider.isDarkMode ? textPrimaryDarkColor : textPrimaryLightColor,
                    headerType: HeaderType.h4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: themeProvider.isDarkMode ? itemBackgroundDarkColor : primaryMaterialColor.shade300,
          centerTitle: false,
          titleSpacing: 0,
          leading: IconButton(
            splashRadius: AppConstants.iconSplashRadius,
            icon: const IconComponent(iconData: CustomIconData.chevronLeft),
            onPressed: () => _isLoading ? null : Navigator.pop(context),
          ),
          actions: [
            _isLoading ? Center(child: Transform.scale(scale: 0.7, child: const CircularProgressIndicator())) : const SizedBox(),
          ],
        ),
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            children: [
              isPageLoading
                  ? const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          int reversedIndex = messages.length - 1 - index;
                          return MessageBubble(
                            messageModel: messages[reversedIndex],
                            loggedUser: loggedUser!,
                          );
                        },
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _pickedImage != null
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              child: Container(
                                color: themeProvider.isDarkMode ? itemBackgroundDarkColor : itemBackgroundLightColor,
                                height: UIHelper.getDeviceHeight(context) / 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Dismissible(
                                    key: const Key("screenshot"),
                                    direction: _isLoading ? DismissDirection.none : DismissDirection.horizontal,
                                    child: RectanglePhotoComponent(
                                      image: _pickedImage,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    onDismissed: (direction) {
                                      setState(() {
                                        _pickedImage = null;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Container(
                      decoration: BoxDecoration(
                          color: themeProvider.isDarkMode ? itemBackgroundDarkColor : itemBackgroundLightColor,
                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextField(
                              style: TextStyle(
                                color: (themeProvider.isDarkMode ? textPrimaryDarkColor : textPrimaryLightColor),
                              ),
                              cursorColor: primaryColor,
                              toolbarOptions: const ToolbarOptions(
                                copy: true,
                                cut: true,
                                paste: true,
                                selectAll: true,
                              ),
                              enableInteractiveSelection: true,
                              enableSuggestions: true,
                              enabled: !_isLoading,
                              enableIMEPersonalizedLearning: true,
                              scribbleEnabled: true,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: themeProvider.isDarkMode ? itemBackgroundDarkColor : itemBackgroundLightColor,
                                hintStyle: TextStyle(color: (themeProvider.isDarkMode ? hintTextDarkColor : hintTextLightColor)),
                                contentPadding: const EdgeInsets.all(10),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                disabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              keyboardType: TextInputType.multiline,
                              controller: chatTextEditingController,
                              minLines: 1,
                              maxLines: 3,
                            ),
                          ),
                          IconButton(
                            splashRadius: AppConstants.iconSplashRadius,
                            icon: const IconComponent(
                              iconData: CustomIconData.image,
                              color: primaryColor,
                            ),
                            onPressed: () {
                              AppFunctions().showMediaSnackbar(context, () {
                                AppFunctions().pickImageFromCamera().then((file) {
                                  setState(() => _pickedImage = file);
                                });
                              }, () {
                                AppFunctions().pickImageFromGallery().then((file) {
                                  setState(() => _pickedImage = file);
                                });
                              });
                            },
                          ),
                          IconButton(
                            splashRadius: AppConstants.iconSplashRadius,
                            icon: IconComponent(
                              iconData: CustomIconData.paperPlaneTop,
                              color: _pickedImage != null
                                  ? primaryColor
                                  : (chatTextEditingController.text.trim().isEmpty || _isLoading || isPageLoading)
                                      ? Colors.grey
                                      : primaryColor,
                            ),
                            onPressed: !_isLoading
                                ? _pickedImage != null
                                    ? () async {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        MessageModel messageModel = MessageModel(
                                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                                            content: chatTextEditingController.text.trim(),
                                            senderMail: loggedUser!.email,
                                            messageDate: DateTime.now().toString());
                                        chatTextEditingController.clear();
                                        await sendMessage(messageModel);
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    : (chatTextEditingController.text.trim().isEmpty || _isLoading || isPageLoading)
                                        ? null
                                        : () async {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            MessageModel messageModel = MessageModel(
                                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                                content: chatTextEditingController.text.trim(),
                                                senderMail: loggedUser!.email,
                                                messageDate: DateTime.now().toString());
                                            chatTextEditingController.clear();
                                            await sendMessage(messageModel);
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          }
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendMessage(MessageModel messageModel) async {
    if (_pickedImage != null) {
      messageModel.hasImage = true;
      messageModel.imageUrl =
          await userService.uploadImage(_pickedImage!, "MessageImages/${loggedUser!.email}/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg") ??
              ImageAssetKeys.noImageUrl;
    }
    setState(() {
      _pickedImage = null;
    });
    await userService.sendMessage(loggedUser!, targetUser!, messageModel);
  }
}
