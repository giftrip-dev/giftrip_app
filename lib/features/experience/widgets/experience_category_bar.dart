import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/features/experience/models/experience_category.dart';

class ExperienceCategoryBar extends StatelessWidget {
  final ExperienceCategory? selectedCategory;
  final Function(ExperienceCategory?) onCategoryChanged;

  const ExperienceCategoryBar({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // 전체 카테고리
            _CategoryChip(
              label: '전체',
              isSelected: selectedCategory == null,
              onTap: () => onCategoryChanged(null),
            ),
            const SizedBox(width: 28),

            // 나머지 카테고리들
            ...ExperienceCategory.values.map((category) {
              return Padding(
                padding: const EdgeInsets.only(right: 32),
                child: _CategoryChip(
                  label: category.label,
                  isSelected: selectedCategory == category,
                  onTap: () => onCategoryChanged(category),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// 카테고리 칩 위젯
class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        decoration: BoxDecoration(
          border: isSelected
              ? Border(
                  bottom: BorderSide(
                    color: AppColors.labelStrong,
                    width: 1.5,
                  ),
                )
              : null,
        ),
        child: Text(
          label,
          style: title_S.copyWith(
            color:
                isSelected ? AppColors.labelStrong : AppColors.labelAlternative,
          ),
        ),
      ),
    );
  }
}
