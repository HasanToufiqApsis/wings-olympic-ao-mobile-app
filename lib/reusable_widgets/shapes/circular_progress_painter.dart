import 'dart:math';

import 'package:flutter/material.dart';

class CircularProgressPainter extends CustomPainter {
  Color? lineColor;
  Color completeColor;
  List<Color>? completedGradientColor;
  double completePercent;
  double width;
  bool? showProgressShadow;

  CircularProgressPainter({
    this.lineColor,
    required this.completeColor,
    this.completedGradientColor,
    required this.completePercent,
    required this.width,
    this.showProgressShadow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    /// At first define the painters in which we will paint our canvas

    /// This is the circle painter to paint the background of the
    /// circular progress bar
    Paint backgroundCirclePainter = Paint()
      ..color = lineColor ?? Colors.white.withOpacity(.1)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    /// This painter will draw a shade behind the completed arch in the
    /// circular progress bar
    Paint shaderPainter = Paint()
      ..color = completeColor.withOpacity(.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    /// This is the arch painter to paint the
    /// completed portion on the circle
    Paint completedArchPainter = Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..shader = LinearGradient(
        colors: completedGradientColor ?? [],
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
      ).createShader(
        Rect.fromCircle(
          center: const Offset(3, 0),
          radius: size.height,
        ),
      );

    /// In this section
    /// We will draw our canvas according to defined painters above

    /// Center of the canvas
    Offset center = Offset(size.width / 2, size.height / 2);

    /// radius of our circle
    double radius = min(size.width / 2, size.height / 2);

    /// Drawing background circle
    canvas.drawCircle(center, radius, backgroundCirclePainter);

    double arcAngle = 2 * pi * (completePercent / 100);

    /// Drawing the shade
    // if (showProgressShadow == true) {
    //   canvas.drawArc(
    //     Rect.fromCircle(center: center, radius: radius),
    //     -pi / 6,
    //     arcAngle + .2,
    //     false,
    //     shaderPainter,
    //   );
    // }

    /// Drawing the completed arch over the background circle
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 7,
      arcAngle,
      false,
      completedArchPainter,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
