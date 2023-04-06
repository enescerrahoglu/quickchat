import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/helpers/ui_helper.dart';
import 'package:flutter/material.dart';

class LinearCountDownTimer extends StatefulWidget {
  final AnimationController controller;
  final Function? completeFunction;
  const LinearCountDownTimer({
    super.key,
    required this.controller,
    this.completeFunction,
  });

  @override
  State<LinearCountDownTimer> createState() => _LinearCountDownTimerState();
}

class _LinearCountDownTimerState extends State<LinearCountDownTimer> with TickerProviderStateMixin {
  late Animation<double> _animation;

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animation = CurvedAnimation(
      parent: widget.controller,
      curve: Curves.linear,
    );
    widget.controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.completeFunction != null) {
        widget.completeFunction!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Stack(
        children: [
          Container(
            color: lightPrimaryColor,
            height: 20,
            width: UIHelper.getDeviceWidth(context),
          ),
          SizeTransition(
            sizeFactor: _animation,
            axis: Axis.horizontal,
            child: Container(
              color: primaryColor,
              height: 20,
            ),
          ),
        ],
      ),
    );
  }
}
