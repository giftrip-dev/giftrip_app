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

  const SubCategoryItem({
    super.key,
    required this.title,
    required this.categoryIndex,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (categoryIndex == 0) {
          // 체험 카테고리인 경우
          final category = ExperienceCategory.fromString(title);
          if (category != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                  create: (context) =>
                      ExperienceViewModel()..changeCategory(category),
                  child: const ExperienceScreen(),
                ),
              ),
            );
          }
        }
      },
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
