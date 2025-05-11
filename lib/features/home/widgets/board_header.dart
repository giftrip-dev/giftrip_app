import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';

class BoardHeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const BoardHeaderWidget({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 27,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: title_L),
          GestureDetector(
            onTap: onPressed,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '더 보기',
                  style: subtitle_XS.copyWith(color: AppColors.labelNatural),
                ),
                const SizedBox(width: 1),
                Icon(
                  LucideIcons.chevronRight,
                  size: 19,
                  color: AppColors.labelNatural,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
