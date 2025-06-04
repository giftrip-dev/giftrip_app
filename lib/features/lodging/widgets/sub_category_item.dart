import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/features/experience/models/experience_category.dart';
import 'package:giftrip/features/experience/screens/experience_screen.dart';
import 'package:giftrip/features/experience/view_models/experience_view_model.dart';
import 'package:provider/provider.dart';

class SubCategoryItem extends StatelessWidget {
  final String title;
  final int categoryIndex;
  final bool isSelected;
  final VoidCallback? onTap;

  const SubCategoryItem({
    super.key,
    required this.title,
    required this.categoryIndex,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        color: isSelected ? const Color(0xFFEAF0FF) : Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: body_M.copyWith(
                  color: AppColors.label,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                color: AppColors.primaryStrong,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
