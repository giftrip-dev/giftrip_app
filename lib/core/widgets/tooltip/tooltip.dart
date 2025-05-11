import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/constants/app_colors.dart';

class CustomTooltip extends StatelessWidget {
  final String text;
  final String? size; // "sm" | "md"
  final bool? isDark; // 검은색 테마 여부
  const CustomTooltip(
      {super.key, required this.text, this.size = "sm", this.isDark = false});

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
              color: isDark! ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              text,
              style: title_XS.copyWith(
                  color: isDark! ? Colors.white : AppColors.labelStrong),
            ),
          ),
          // 화살표 이미지
          Positioned(
            bottom: 0,
            child: Image.asset(
              'assets/images/icon/arrow_down${isDark! ? "" : "_white"}.png',
              width: 16,
              height: 16,
            ),
          ),
        ],
      ),
    );
  }
}
