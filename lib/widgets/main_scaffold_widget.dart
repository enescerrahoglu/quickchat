import 'package:flutter/material.dart';
import 'package:quickchat/constants/color_constants.dart';

class MainScaffoldWidget extends StatelessWidget {
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
  final Color titleColor;

  const MainScaffoldWidget({
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
    this.titleColor = Colors.white,
  }) : super(key: key);

  bool defaultFunction() {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        bool value = popScopeFunction == null ? defaultFunction() : popScopeFunction!();
        return Future.value(value);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: hasAppBar
            ? AppBar(
                toolbarHeight: toolbarHeight,
                title: (titleWidget != null) ? titleWidget : ((title != null && title!.isNotEmpty) ? Text(title!, style: TextStyle(color: titleColor)) : null),
                centerTitle: centerTitle,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8),
                  child: leadingWidget,
                ),
                backgroundColor: primaryColor,
                leadingWidth: leadingWidth,
                actions: actionList,
              )
            : null,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
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
