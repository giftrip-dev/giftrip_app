import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';

class CategoryTab extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryTab({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        width: 100,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey[100],
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: isSelected
              ? subtitle_M.copyWith(color: AppColors.labelStrong)
              : subtitle_M.copyWith(color: AppColors.labelAlternative),
        ),
      ),
    );
  }
}
