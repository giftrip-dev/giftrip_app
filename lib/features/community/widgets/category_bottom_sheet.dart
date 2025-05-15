import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/enum/community_enum.dart';

class WriteCategoryBottomSheet extends StatelessWidget {
  final BeautyCategory selectedCategory;
  final Function(BeautyCategory) onCategorySelected;

  const WriteCategoryBottomSheet({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 56),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: BeautyCategory.values.map((category) {
          final bool isSelected = category == selectedCategory;

          return GestureDetector(
            onTap: () {
              onCategorySelected(category);
              Navigator.pop(context);
            },
            child: Container(
              width: double.infinity, // 전체 영역 터치 가능하도록 설정
              padding: const EdgeInsets.symmetric(vertical: 15), // 터치 영역 확대
              alignment: Alignment.centerLeft, // 텍스트 정렬
              child: Row(
                mainAxisSize: MainAxisSize.max, // Row가 가능한 최대 크기를 차지하도록 설정
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    // 터치 가능한 범위를 Row 전체로 확장
                    child: Text(
                      BeautyCategory.toKoreanString(category),
                      style: subtitle_L,
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        LucideIcons.check,
                        color: Colors.white,
                        size: 18,
                        weight: 10,
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
