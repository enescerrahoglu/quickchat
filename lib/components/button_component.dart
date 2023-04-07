import 'package:quickchat/components/icon_component.dart';
import 'package:flutter/material.dart';
import 'package:quickchat/constants/color_constants.dart';

class ButtonComponent extends StatefulWidget {
  final String text;
  final bool isWide;
  final Color color;
  final bool isOutLined;
  final CustomIconData? icon;
  final bool isGradient;
  final List<Color> gradientColors;
  final double topPadding;
  final double bottomPadding;
  final double rightPadding;
  final double leftPadding;
  final double textPadding;
  final bool isLoading;
  final Function()? onPressed;

  const ButtonComponent({
    Key? key,
    required this.text,
    this.isWide = false,
    this.color = primaryColor,
    this.isOutLined = false,
    this.icon,
    this.isGradient = false,
    this.gradientColors = const [
      Color.fromRGBO(1, 79, 134, 1),
      Color.fromRGBO(1, 79, 134, .6),
    ],
    this.topPadding = 0,
    this.bottomPadding = 0,
    this.rightPadding = 0,
    this.leftPadding = 0,
    this.textPadding = 12,
    this.isLoading = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<ButtonComponent> createState() => _ButtonComponentState();
}

class _ButtonComponentState extends State<ButtonComponent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.topPadding, bottom: widget.bottomPadding, right: widget.rightPadding, left: widget.leftPadding),
      child: !widget.isGradient
          ? !widget.isOutLined
              ? ElevatedButton.icon(
                  onPressed: widget.onPressed,
                  style: OutlinedButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    elevation: 0,
                    minimumSize: widget.isWide == true ? const Size.fromHeight(10) : const Size(10, 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: widget.color,
                  ),
                  icon: widget.icon == null
                      ? const SizedBox()
                      : IconComponent(
                          iconData: widget.icon!,
                          color: Colors.white,
                        ),
                  label: Padding(
                    padding: EdgeInsets.all(widget.textPadding),
                    child: widget.isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: HSLColor.fromColor(widget.color).withLightness(0.8).toColor(),
                              backgroundColor: HSLColor.fromColor(widget.color).withLightness(0.6).toColor(),
                            ),
                          )
                        : SizedBox(
                            height: 24,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                widget.text,
                              ),
                            ),
                          ),
                  ),
                )
              : OutlinedButton.icon(
                  onPressed: widget.onPressed,
                  style: OutlinedButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: widget.color,
                    disabledForegroundColor: widget.color.withOpacity(0.38),
                    elevation: 0,
                    minimumSize: widget.isWide == true ? const Size.fromHeight(10) : const Size(10, 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    side: BorderSide(
                      width: 1,
                      color: widget.color,
                    ),
                  ),
                  icon: widget.icon == null
                      ? const SizedBox()
                      : IconComponent(
                          iconData: widget.icon!,
                          color: Colors.white,
                        ),
                  label: Padding(
                    padding: EdgeInsets.all(widget.textPadding),
                    child: widget.isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: HSLColor.fromColor(widget.color).withLightness(0.2).toColor(),
                              backgroundColor: HSLColor.fromColor(widget.color).withLightness(0.3).toColor(),
                            ))
                        : SizedBox(
                            height: 24,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                widget.text,
                                style: TextStyle(color: widget.color),
                              ),
                            ),
                          ),
                  ),
                )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 1.0],
                  colors: widget.gradientColors,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ElevatedButton.icon(
                onPressed: widget.onPressed,
                style: OutlinedButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  elevation: 0,
                  minimumSize: widget.isWide == true ? const Size.fromHeight(10) : const Size(10, 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.transparent,
                ),
                icon: widget.icon == null
                    ? const SizedBox()
                    : IconComponent(
                        iconData: widget.icon!,
                        color: Colors.white,
                      ),
                label: Padding(
                  padding: EdgeInsets.all(widget.textPadding),
                  child: widget.isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: HSLColor.fromColor(widget.color).withLightness(0.2).toColor(),
                            backgroundColor: HSLColor.fromColor(widget.color).withLightness(0.3).toColor(),
                          ))
                      : SizedBox(
                          height: 24,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              widget.text,
                            ),
                          ),
                        ),
                ),
              ),
            ),
    );
  }
}
