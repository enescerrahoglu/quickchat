import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quickchat/components/text_component.dart';
import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/constants/image_constants.dart';
import 'package:quickchat/helpers/ui_helper.dart';
import 'package:quickchat/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:quickchat/providers/theme_provider.dart';

class UserRowWidget extends StatefulWidget {
  final UserModel userModel;
  final Widget? suffixWidget;
  final Function? onTap;
  const UserRowWidget({super.key, required this.userModel, this.suffixWidget, this.onTap});

  @override
  State<UserRowWidget> createState() => _UserRowWidgetState();
}

class _UserRowWidgetState extends State<UserRowWidget> {
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
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: SizedBox(
                              width: UIHelper.getDeviceWidth(context) / 7,
                              height: UIHelper.getDeviceWidth(context) / 7,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    color: primaryColor.withOpacity(0.1),
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Image.asset(ImageAssetKeys.defaultProfilePhoto),
                                      imageUrl: widget.userModel.photoUrl,
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
                                    text: "${widget.userModel.firstName} ${widget.userModel.lastName}",
                                    headerType: HeaderType.h5,
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                  ),
                                  TextComponent(
                                    text: widget.userModel.email,
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
