import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quickchat/components/text_component.dart';
import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/constants/image_constants.dart';
import 'package:quickchat/constants/string_constants.dart';
import 'package:quickchat/helpers/ui_helper.dart';
import 'package:quickchat/localization/app_localization.dart';
import 'package:quickchat/models/chat_model.dart';
import 'package:quickchat/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:quickchat/providers/theme_provider.dart';

class ChatRowWidget extends StatefulWidget {
  final UserModel loggedUser;
  final ChatModel chatModel;
  final Widget? suffixWidget;
  final Function? onTap;
  const ChatRowWidget({super.key, required this.loggedUser, required this.chatModel, this.suffixWidget, this.onTap});

  @override
  State<ChatRowWidget> createState() => _ChatRowWidgetState();
}

class _ChatRowWidgetState extends State<ChatRowWidget> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        decoration: BoxDecoration(
          color: themeProvider.isDarkMode ? itemBackgroundDarkColor : itemBackgroundLightColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                widget.onTap != null ? widget.onTap!() : () {};
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: SizedBox(
                              width: UIHelper.getDeviceWidth(context) / 8,
                              height: UIHelper.getDeviceWidth(context) / 8,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    color: primaryColor.withOpacity(0.1),
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Image.asset(ImageAssetKeys.defaultProfilePhoto),
                                      imageUrl: widget.chatModel.targetUser.photoUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextComponent(
                                    text: widget.loggedUser.email == widget.chatModel.targetUser.email
                                        ? getTranslated(context, CommonKeys.yourself)
                                        : "${widget.chatModel.targetUser.firstName} ${widget.chatModel.targetUser.lastName}",
                                    headerType: HeaderType.h5,
                                    fontWeight: FontWeight.bold,
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                  ),
                                  const SizedBox(height: 3),
                                  TextComponent(
                                    text: widget.chatModel.lastMessage.senderMail == widget.loggedUser.email
                                        ? "${getTranslated(context, CommonKeys.you)}: ${widget.chatModel.lastMessage.content}"
                                        : widget.chatModel.lastMessage.content,
                                    color: themeProvider.isDarkMode ? darkPrimaryColor : lightPrimaryColor,
                                    headerType: HeaderType.h7,
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          widget.suffixWidget != null ? Padding(padding: const EdgeInsets.only(right: 10), child: widget.suffixWidget) : const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
