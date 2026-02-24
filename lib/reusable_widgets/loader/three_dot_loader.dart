import 'package:flutter/material.dart';

class ThreeDotLoader extends StatefulWidget {
  final double dotSize;
  final double spacing;
  final Color color;
  final Duration duration;

  const ThreeDotLoader({
    super.key,
    this.dotSize = 2.0,
    this.spacing = 4.0,
    this.color = Colors.black,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<ThreeDotLoader> createState() => _ThreeDotLoaderState();
}

class _ThreeDotLoaderState extends State<ThreeDotLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isDotVisible(int index) {
    final t = _controller.value;

    // Break animation into 4 phases
    // 0.0–0.25: no dots
    // 0.25–0.5: show dot 1
    // 0.5–0.75: show dot 1 + 2
    // 0.75–1.0: show dot 1 + 2 + 3
    if (t < 0.25) return false;
    if (t < 0.5) return index == 0;
    if (t < 0.75) return index <= 1;
    return index <= 2;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(3, (i) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
              child: Opacity(
                opacity: _isDotVisible(i) ? 1.0 : 0.0,
                child: Container(
                  width: widget.dotSize,
                  height: widget.dotSize,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
