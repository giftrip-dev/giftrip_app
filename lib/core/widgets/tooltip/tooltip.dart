import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_text_style.dart';

class CustomTooltip extends StatelessWidget {
  final String text;
  final String? size; // "sm" | "md"
  const CustomTooltip({super.key, required this.text, this.size = "sm"});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size == "md" ? 60 : 46,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF606060),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              text,
              style: title_XS.copyWith(color: Colors.white),
            ),
          ),
          // 화살표 이미지
          Positioned(
            bottom: 0,
            child: Image.asset(
              'assets/png/icons/arrow_down.png',
              width: 16,
              height: 16,
            ),
          ),
        ],
      ),
    );
  }
}
