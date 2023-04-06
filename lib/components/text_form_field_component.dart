import 'package:quickchat/components/icon_component.dart';
import 'package:quickchat/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/color_constants.dart';

class TextFormFieldComponent extends StatefulWidget {
  final BuildContext context;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final CustomIconData? iconData;
  final String? hintText;
  final bool readOnly;
  final bool enabled;
  final bool enableSuggestions;
  final bool autocorrect;
  final bool autofocus;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final double topPadding;
  final double bottomPadding;
  final double rightPadding;
  final double leftPadding;
  final Color? itemBackgroundColor;
  final bool isPassword;
  final TextInputAction textInputAction;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? maxCharacter;

  const TextFormFieldComponent({
    Key? key,
    required this.context,
    required this.textEditingController,
    this.keyboardType = TextInputType.text,
    this.iconData,
    this.hintText,
    this.readOnly = false,
    this.enabled = true,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.topPadding = 0,
    this.bottomPadding = 0,
    this.rightPadding = 0,
    this.leftPadding = 0,
    this.itemBackgroundColor,
    this.isPassword = false,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
    this.onChanged,
    this.focusNode,
    this.maxLines = 1,
    this.maxCharacter = 1000,
  }) : super(key: key);

  @override
  State<TextFormFieldComponent> createState() => _TextFormFieldComponentState();
}

class _TextFormFieldComponentState extends State<TextFormFieldComponent> {
  bool isObscured = true;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: EdgeInsets.only(top: widget.topPadding, bottom: widget.bottomPadding, right: widget.rightPadding, left: widget.leftPadding),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.top,
        textAlign: widget.textAlign,
        expands: widget.maxLines == null ? true : false,
        minLines: null,
        maxLines: widget.maxLines,
        enableSuggestions: widget.enableSuggestions,
        autocorrect: widget.autocorrect,
        autofocus: widget.autofocus,
        style: TextStyle(
          color: (themeProvider.isDarkMode ? textPrimaryDarkColor : textPrimaryLightColor),
        ),
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onSubmitted,
        onChanged: widget.onChanged,
        focusNode: widget.focusNode,
        validator: widget.validator,
        controller: widget.textEditingController,
        keyboardType: widget.keyboardType,
        textCapitalization: widget.textCapitalization,
        readOnly: widget.readOnly,
        enabled: widget.enabled,
        inputFormatters: [LengthLimitingTextInputFormatter(widget.maxCharacter)],
        decoration: InputDecoration(
          hintStyle: TextStyle(color: (themeProvider.isDarkMode ? hintTextDarkColor : hintTextLightColor)),
          errorStyle: const TextStyle(height: 0),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: dangerDark,
              width: 1,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(15),
          errorMaxLines: 3,
          prefixIcon: widget.iconData != null
              ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: IconComponent(
                    iconData: widget.iconData!,
                    color: primaryColor,
                  ),
                )
              : null,
          hintText: widget.hintText,
          fillColor: widget.itemBackgroundColor ?? (themeProvider.isDarkMode ? itemBackgroundDarkColor : itemBackgroundLightColor),
          filled: true,
          suffixIcon: widget.isPassword == true
              ? InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      isObscured = !isObscured;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10, top: 15, bottom: 15),
                    child: IconComponent(
                      iconData: isObscured ? CustomIconData.eye : CustomIconData.eyeSlash,
                      color: primaryColor,
                    ),
                  ),
                )
              : null,
        ),
        cursorColor: primaryColor,
        scrollPadding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        obscureText: widget.isPassword
            ? isObscured
                ? true
                : false
            : false,
      ),
    );
  }
}
