import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickchat/components/circular_photo_component.dart';
import 'package:quickchat/components/icon_component.dart';
import 'package:quickchat/components/marquee_text_component.dart';
import 'package:quickchat/components/text_component.dart';
import 'package:quickchat/constants/app_constants.dart';
import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/constants/image_constants.dart';
import 'package:quickchat/localization/app_localization.dart';
import 'package:quickchat/models/message_model.dart';
import 'package:quickchat/models/user_model.dart';
import 'package:quickchat/providers/provider_container.dart';
import 'package:quickchat/providers/theme_provider.dart';
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
  bool isLoading = false;
  bool isPageLoading = false;

  UserModel? loggedUser;
  UserModel? targetUser;

  List<MessageModel> messages = [];

  @override
  void dispose() {
    chatTextEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    loggedUser = ref.read(loggedUserProvider);
    Future.delayed(Duration.zero, () async {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        setState(() {
          isPageLoading = true;
        });
        targetUser = ModalRoute.of(context)!.settings.arguments as UserModel;
        messages = await userService.getMessages(loggedUser!, targetUser!);
        debugPrint(messages.length.toString());
        setState(() {
          isPageLoading = false;
        });
      } else {}
      if (targetUser == null) {
        if (mounted) {
          Navigator.pop(context);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {},
          child: Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 35,
                  height: 35,
                  child: CircularPhotoComponent(
                    url: targetUser != null ? targetUser!.photoUrl : ImageAssetKeys.defaultProfilePhotoUrl,
                    smallCircularProgressIndicator: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: MarqueeTextComponent(
                  text: getTranslated(
                    context,
                    targetUser != null ? "${targetUser!.firstName} ${targetUser!.lastName}" : "",
                  ),
                  color: Colors.white,
                  headerType: HeaderType.h4,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: themeProvider.isDarkMode ? itemBackgroundDarkColor : primaryColor,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          splashRadius: AppConstants.iconSplashRadius,
          icon: const IconComponent(iconData: CustomIconData.chevronLeft, color: iconDarkColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
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
                padding: const EdgeInsets.only(top: 10),
                child: Container(
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
                          enabled: true,
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
                        icon: IconComponent(
                          iconData: CustomIconData.paperPlaneTop,
                          color: (chatTextEditingController.text.trim().isEmpty || isLoading || isPageLoading) ? Colors.grey : primaryColor,
                        ),
                        onPressed: (chatTextEditingController.text.trim().isEmpty || isLoading || isPageLoading)
                            ? null
                            : () async {
                                MessageModel messageModel = MessageModel(
                                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                                    content: chatTextEditingController.text,
                                    senderMail: loggedUser!.email,
                                    messageDate: DateTime.now().toString());
                                await userService.sendMessage(loggedUser!, targetUser!, messageModel);
                              },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage() async {}
}