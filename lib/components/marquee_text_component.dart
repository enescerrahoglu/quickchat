import 'package:quickchat/components/icon_component.dart';
import 'package:quickchat/components/text_component.dart';
import 'package:quickchat/widgets/marquee_widget.dart';
import 'package:flutter/widgets.dart';

class MarqueeTextComponent extends StatefulWidget {
  final String text;
  final HeaderType headerType;
  final Color? color;
  final FontWeight fontWeight;
  final CustomIconData? iconData;
  final CustomIconWeight iconWeight;
  const MarqueeTextComponent({
    super.key,
    required this.text,
    this.headerType = HeaderType.h5,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.iconData,
    this.iconWeight = CustomIconWeight.solid,
  });

  @override
  State<MarqueeTextComponent> createState() => _MarqueeTextComponentState();
}

class _MarqueeTextComponentState extends State<MarqueeTextComponent> {
  @override
  Widget build(BuildContext context) {
    return MarqueeWidget(
      child: Row(
        children: [
          widget.iconData != null
              ? SizedBox(
                  width: getHeaderTypeValue(widget.headerType),
                  child: IconComponent(
                    iconData: widget.iconData!,
                    color: widget.color,
                    iconWeight: widget.iconWeight,
                  ),
                )
              : const SizedBox(),
          widget.iconData != null ? const SizedBox(width: 10) : const SizedBox(),
          TextComponent(
            text: widget.text,
            headerType: widget.headerType,
            fontWeight: widget.fontWeight,
            color: widget.color,
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
        ],
      ),
    );
  }
}
