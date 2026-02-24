import 'package:flutter/material.dart';

class TakaIcon extends StatelessWidget {
  final double? size;
  final FontWeight? weight;
  final Color? color;

  const TakaIcon({
    super.key,
    this.size,
    this.weight,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '৳',
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: Colors.white,
      ),
    );
  }
}
