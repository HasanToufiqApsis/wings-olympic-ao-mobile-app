import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'dart:math' as math;

import '../../../reusable_widgets/language_textbox.dart';

class AttendanceWidget extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final Color dotColor;
  final IconData? icon;
  final String text;
  final void Function()? onTap;
  final bool? enabled;

  const AttendanceWidget({
    Key? key,
    required this.height,
    required this.width,
    required this.color,
    required this.dotColor,
    this.icon,
    required this.text,
    this.onTap, this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(enabled != false){
          onTap?.call();
        }else{

        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: enabled == false ? Colors.grey.withOpacity(.3): color,
          ),
          child: CustomPaint(
            painter: DashRectPainter(
              color: enabled == false ? Colors.grey: dotColor,
              strokeWidth: 2,
              gap: 6,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 25,
                  color: enabled == false ? Colors.grey: dotColor,
                ),
                SizedBox(width: 3.w,),
                LangText(
                  text,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashRectPainter extends CustomPainter {
  double strokeWidth;
  Color color;
  double gap;

  DashRectPainter(
      {this.strokeWidth = 5.0, this.color = Colors.red, this.gap = 5.0});

  @override
  void paint(Canvas canvas, Size size) {
    Paint dashedPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    double x = size.width;
    double y = size.height;

    Path _topPath = getDashedPath(
      a: const math.Point(0, 0),
      b: math.Point(x, 0),
      gap: gap,
    );

    Path _rightPath = getDashedPath(
      a: math.Point(x, 0),
      b: math.Point(x, y),
      gap: gap,
    );

    Path _bottomPath = getDashedPath(
      a: math.Point(0, y),
      b: math.Point(x, y),
      gap: gap,
    );

    Path _leftPath = getDashedPath(
      a: const math.Point(0, 0),
      b: math.Point(0.001, y),
      gap: gap,
    );

    canvas.drawPath(_topPath, dashedPaint);
    canvas.drawPath(_rightPath, dashedPaint);
    canvas.drawPath(_bottomPath, dashedPaint);
    canvas.drawPath(_leftPath, dashedPaint);
  }

  Path getDashedPath({
    required math.Point<double> a,
    required math.Point<double> b,
    required gap,
  }) {
    Size size = Size(b.x - a.x, b.y - a.y);
    Path path = Path();
    path.moveTo(a.x, a.y);
    bool shouldDraw = true;
    math.Point currentPoint = math.Point(a.x, a.y);

    num radians = math.atan(size.height / size.width);

    num dx = math.cos(radians) * gap < 0
        ? math.cos(radians) * gap * -1
        : math.cos(radians) * gap;

    num dy = math.sin(radians) * gap < 0
        ? math.sin(radians) * gap * -1
        : math.sin(radians) * gap;

    while (currentPoint.x <= b.x && currentPoint.y <= b.y) {
      shouldDraw
          ? path.lineTo(currentPoint.x.toDouble(), currentPoint.y.toDouble())
          : path.moveTo(currentPoint.x.toDouble(), currentPoint.y.toDouble());
      shouldDraw = !shouldDraw;
      currentPoint = math.Point(
        currentPoint.x + dx,
        currentPoint.y + dy,
      );
    }
    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
