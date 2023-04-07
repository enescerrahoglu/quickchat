import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as provider;
import 'package:quickchat/components/text_component.dart';
import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/models/message_model.dart';
import 'package:quickchat/models/user_model.dart';
import 'package:quickchat/providers/theme_provider.dart';

class MessageBubble extends ConsumerStatefulWidget {
  final MessageModel messageModel;
  final UserModel loggedUser;
  const MessageBubble({super.key, required this.messageModel, required this.loggedUser});

  @override
  ConsumerState<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends ConsumerState<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    return widget.messageModel.senderMail == widget.loggedUser.email
        ? Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                color: (themeProvider.isDarkMode ? itemBackgroundDarkColor : itemBackgroundLightColor),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10), topRight: Radius.circular(3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onLongPress: () async {
                        await Clipboard.setData(ClipboardData(text: widget.messageModel.content));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextComponent(
                            text: widget.messageModel.content,
                            textAlign: TextAlign.start,
                            headerType: HeaderType.h5,
                          ),
                          const SizedBox(height: 3),
                          TextComponent(
                            text: DateFormat("dd.MM.yyyy HH:mm").format(DateTime.parse(widget.messageModel.messageDate)),
                            textAlign: TextAlign.end,
                            color: (themeProvider.isDarkMode ? itemBackgroundLightColor : itemBackgroundDarkColor),
                            headerType: HeaderType.h8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(3), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10), topRight: Radius.circular(10)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onLongPress: () async {
                        await Clipboard.setData(ClipboardData(text: widget.messageModel.content));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextComponent(
                            text: widget.messageModel.content,
                            textAlign: TextAlign.start,
                            headerType: HeaderType.h5,
                          ),
                          const SizedBox(height: 3),
                          TextComponent(
                            text: DateFormat("dd.MM.yyyy HH:mm").format(DateTime.parse(widget.messageModel.messageDate)),
                            textAlign: TextAlign.end,
                            color: (themeProvider.isDarkMode ? itemBackgroundLightColor : itemBackgroundDarkColor),
                            headerType: HeaderType.h8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
