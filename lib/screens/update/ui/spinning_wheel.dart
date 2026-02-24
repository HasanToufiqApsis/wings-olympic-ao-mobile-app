import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SpinningWheel extends StatefulWidget {
  static const routeName = "/spinningwheel";
  const SpinningWheel({Key? key}) : super(key: key);

  @override
  _SpinningWheelState createState() => _SpinningWheelState();
}

class _SpinningWheelState extends State<SpinningWheel>
    with TickerProviderStateMixin {
  // Create a controller
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 5),
    vsync: this,
  )..repeat(reverse: false);

  // Create an animation with value of type "double"
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );

  final Tween<double> turnsTween = Tween<double>(
    begin: 1,
    end: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          bottom: 5.h,
          right: 31.w,
          child: RotationTransition(
            turns: _animation,
            child: Image.asset(
              'assets/wheel.png',
              color: const Color(0xff1C3763),
              height: 16.h,
              width: 16.h,
            ),
          ),
        ),
        Positioned(
          bottom: 20.h,
          right: 20.w,
          child: RotationTransition(
            turns: turnsTween.animate(_controller),
            child: Image.asset(
              'assets/wheel.png',
              color: const Color(0xff5B79AA),
              height: 20.h,
              width: 20.h,
            ),
          ),
        ),
        Positioned(
          bottom: 13.h,
          right: 11.w,
          child: RotationTransition(
            turns: _animation,
            child: Image.asset(
              'assets/wheel.png',
              color: const Color(0xffBED6FB),
              height: 10.h,
              width: 10.h,
            ),
          ),
        ),
      ],
    );
  }
}
