import 'package:flutter/material.dart';
import 'dart:math';

class CustomCircularProgressPainter extends CustomPainter {
  final double progress; // value between 0.0 to 1.0
  final Color color;
  final double strokeWidth;

  CustomCircularProgressPainter({
    required this.progress,
    this.color = Colors.blue,
    this.strokeWidth = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = min(size.width, size.height) / 2;

    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw background circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc, starting from top (−π/2 radians)
    double startAngle = -pi / 2;
    double sweepAngle = 2 * pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
