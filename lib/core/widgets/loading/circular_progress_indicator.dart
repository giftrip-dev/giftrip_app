import 'package:flutter/material.dart';

class AppCircularProgress extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color? color;

  const AppCircularProgress({
    super.key,
    this.size = 20, // 기본 크기
    this.strokeWidth = 2.0, // 기본 두께
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: color ?? Theme.of(context).progressIndicatorTheme.color,
      ),
    );
  }
}
