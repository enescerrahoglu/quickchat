import 'package:quickchat/constants/color_constants.dart';
import 'package:flutter/cupertino.dart';

typedef OnChangeCallback = void Function(dynamic value);

class SwitchComponent extends StatelessWidget {
  final bool switchValue;
  final OnChangeCallback switchFunction;
  final double scale;

  const SwitchComponent({Key? key, required this.switchValue, required this.switchFunction, this.scale = 0.7}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: CupertinoSwitch(
        value: switchValue,
        onChanged: (value) {
          switchFunction(value);
        },
        activeColor: primaryColor,
      ),
    );
  }
}
