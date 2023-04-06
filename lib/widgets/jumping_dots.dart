import 'package:flutter/material.dart';

class DotWidget extends StatefulWidget {
  final Color dotColor;
  final int dotSize;
  const DotWidget({Key? key, this.dotColor = Colors.black, this.dotSize = 7}) : super(key: key);

  @override
  State<DotWidget> createState() => _DotWidgetState();
}

class _DotWidgetState extends State<DotWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: widget.dotColor),
      height: widget.dotSize.toDouble(),
      width: widget.dotSize.toDouble(),
    );
  }
}

class JumpingDots extends StatefulWidget {
  final int numberOfDots;
  final Color dotColor;
  final int dotSize;
  const JumpingDots({Key? key, this.numberOfDots = 3, this.dotColor = Colors.black, this.dotSize = 7}) : super(key: key);

  @override
  State<JumpingDots> createState() => _JumpingDotsState();
}

class _JumpingDotsState extends State<JumpingDots> with TickerProviderStateMixin {
  late List _animationControllers;
  final List<Animation> _animations = [];
  int animationDuration = 200;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.numberOfDots, (index) {
            return AnimatedBuilder(
              animation: _animationControllers[index],
              builder: (context, child) {
                return Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    child: Transform.translate(
                      offset: Offset(0, _animations[index].value / 2),
                      child: DotWidget(dotColor: widget.dotColor, dotSize: widget.dotSize),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _initAnimation() {
    _animationControllers = List.generate(
      widget.numberOfDots,
      (index) {
        return AnimationController(vsync: this, duration: Duration(milliseconds: animationDuration));
      },
    ).toList();

    for (int i = 0; i < widget.numberOfDots; i++) {
      _animations.add(Tween<double>(begin: 0, end: -20).animate(_animationControllers[i]));
    }

    for (int i = 0; i < widget.numberOfDots; i++) {
      _animationControllers[i].addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationControllers[i].reverse();
          if (i != widget.numberOfDots - 1) {
            _animationControllers[i + 1].forward();
          }
        }
        if (i == widget.numberOfDots - 1 && status == AnimationStatus.dismissed) {
          _animationControllers[0].forward();
        }
      });
    }
    _animationControllers.first.forward();
  }
}
