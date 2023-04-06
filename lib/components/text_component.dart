import 'package:flutter/material.dart';

class TextComponent extends StatefulWidget {
  final String text;
  final Color? color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final HeaderType? headerType;
  final TextOverflow? overflow;
  final bool? softWrap;
  final int? maxLines;
  final bool hasShadow;
  const TextComponent({
    Key? key,
    required this.text,
    this.color,
    this.textAlign = TextAlign.center,
    this.fontWeight = FontWeight.normal,
    this.headerType,
    this.overflow,
    this.softWrap,
    this.maxLines,
    this.hasShadow = false,
  }) : super(key: key);

  @override
  State<TextComponent> createState() => _TextComponentState();
}

class _TextComponentState extends State<TextComponent> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      textAlign: widget.textAlign,
      style: TextStyle(
        color: widget.color,
        fontSize: getHeaderTypeValue(widget.headerType ?? HeaderType.h5),
        fontWeight: widget.fontWeight,
        shadows: widget.hasShadow
            ? const [
                Shadow(
                  offset: Offset(0.5, 0.5),
                  blurRadius: 10.0,
                  color: Colors.grey,
                ),
              ]
            : null,
      ),
      overflow: widget.overflow,
      softWrap: widget.softWrap,
      maxLines: widget.maxLines,
    );
  }
}

enum HeaderType {
  h0,
  h1,
  h2,
  h3,
  h4,
  h5,
  h6,
  h7,
  h8,
}

double getHeaderTypeValue(HeaderType headerType) {
  switch (headerType) {
    case HeaderType.h0:
      return 28;
    case HeaderType.h1:
      return 24;
    case HeaderType.h2:
      return 22;
    case HeaderType.h3:
      return 20;
    case HeaderType.h4:
      return 18;
    case HeaderType.h5:
      return 16;
    case HeaderType.h6:
      return 14;
    case HeaderType.h7:
      return 12;
    case HeaderType.h8:
      return 10;
    default:
      return 14;
  }
}
