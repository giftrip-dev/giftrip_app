import 'package:flutter/material.dart';

// 입력 필드 외부 영역 터치 시 포커스 잃게 하는 위젯
class TapOutsideUnfocusWrapper extends StatelessWidget {
  final Widget child;

  const TapOutsideUnfocusWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: child,
    );
  }
}
