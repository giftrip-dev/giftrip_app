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
  final VoidCallback? onTap;

  const SubCategoryItem({
    super.key,
    required this.title,
    required this.categoryIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Text(
          title,
          style: body_M.copyWith(color: AppColors.label),
        ),
      ),
    );
  }
}
