import 'package:quickchat/components/text_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickchat/providers/theme_provider.dart';

class BaseScaffoldWidget extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget> widgetList;
  final bool isKeyboardUsed;
  final bool centerTitle;
  final bool hasAppBar;
  final Widget? leadingWidget;
  final double? leadingWidth;
  final double? toolbarHeight;
  final double topPadding;
  final double bottomPadding;
  final double rightPadding;
  final double leftPadding;
  final List<Widget>? actionList;
  final Function? popScopeFunction;

  const BaseScaffoldWidget({
    Key? key,
    this.title,
    this.titleWidget,
    required this.widgetList,
    this.isKeyboardUsed = false,
    this.centerTitle = true,
    this.hasAppBar = true,
    this.leadingWidget,
    this.leadingWidth,
    this.toolbarHeight,
    this.topPadding = 10,
    this.bottomPadding = 10,
    this.rightPadding = 10,
    this.leftPadding = 10,
    this.actionList,
    this.popScopeFunction,
  }) : super(key: key);

  defaultFunction() {
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return WillPopScope(
      onWillPop: () {
        return popScopeFunction == null ? defaultFunction() : popScopeFunction!();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: hasAppBar
            ? AppBar(
                toolbarHeight: toolbarHeight,
                title: (titleWidget != null)
                    ? titleWidget
                    : ((title != null && title!.isNotEmpty)
                        ? TextComponent(
                            text: title!,
                            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                          )
                        : null),
                centerTitle: centerTitle,
                leading: leadingWidget,
                leadingWidth: leadingWidth,
                actions: actionList,
              )
            : null,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding, right: rightPadding, left: leftPadding),
                  child: Column(
                    children: widgetList,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
