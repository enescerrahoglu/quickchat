import 'package:flutter/material.dart';
import 'package:quickchat/components/text_component.dart';
import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ListViewItem {
  String title;
  String? subTitle;
  Widget? prefixWidget;
  Widget? suffixWidget;
  Function? onTap;
  Function? suffixOnTap;
  bool hasPrefixSpace;
  bool hasSuffixSpace;
  bool isVisible;

  ListViewItem({
    required this.title,
    this.subTitle,
    this.prefixWidget,
    this.suffixWidget,
    this.onTap,
    this.suffixOnTap,
    this.hasPrefixSpace = true,
    this.hasSuffixSpace = false,
    this.isVisible = true,
  });
}

class ListViewComponent extends StatefulWidget {
  final List<ListViewItem> itemList;
  final Color borderColor;
  final bool hasBorder;
  const ListViewComponent({
    Key? key,
    required this.itemList,
    this.borderColor = Colors.transparent,
    this.hasBorder = true,
  }) : super(key: key);

  @override
  State<ListViewComponent> createState() => _ListViewComponentState();
}

class _ListViewComponentState extends State<ListViewComponent> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    widget.itemList.removeWhere((element) => element.isVisible == false);
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        decoration: BoxDecoration(
          border: widget.hasBorder ? Border.all(color: widget.borderColor) : null,
          color: themeProvider.isDarkMode ? itemBackgroundDarkColor : itemBackgroundLightColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: widget.itemList.map(
              (item) {
                return item.isVisible
                    ? Column(
                        children: [
                          InkWell(
                            onTap: () {
                              item.onTap != null ? item.onTap!() : () {};
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  item.prefixWidget != null
                                      ? Padding(
                                          padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                                          child: item.prefixWidget,
                                        )
                                      : const SizedBox(),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextComponent(
                                            text: item.title,
                                            headerType: HeaderType.h5,
                                            color: themeProvider.isDarkMode ? textPrimaryDarkColor : textPrimaryLightColor,
                                            maxLines: 1,
                                            overflow: TextOverflow.fade,
                                            softWrap: false,
                                          ),
                                          item.subTitle != null && item.subTitle!.isNotEmpty
                                              ? TextComponent(
                                                  text: item.subTitle!,
                                                  headerType: HeaderType.h6,
                                                  color: themeProvider.isDarkMode ? textSecondaryDarkColor : textSecondaryLightColor,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false,
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  item.suffixWidget != null
                                      ? Padding(
                                          padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                                          child: item.suffixOnTap != null
                                              ? InkWell(
                                                  child: item.suffixWidget,
                                                  onTap: () {
                                                    item.suffixOnTap!();
                                                  },
                                                )
                                              : item.suffixWidget,
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                          widget.itemList.indexOf(item) != widget.itemList.length - 1
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(thickness: 1, color: themeProvider.isDarkMode ? itemDividerDarkColor : itemDividerLightColor),
                                )
                              : const SizedBox(),
                        ],
                      )
                    : const SizedBox();
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}
