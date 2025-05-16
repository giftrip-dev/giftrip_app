import 'package:flutter/material.dart';
import 'package:giftrip/features/lodging/models/lodging_category.dart';
import 'package:giftrip/features/lodging/widgets/lodging_category_bar.dart';

class PersistentCategoryBarDelegate extends SliverPersistentHeaderDelegate {
  final LodgingCategory? selectedCategory;
  final Function(LodgingCategory?) onCategoryChanged;

  PersistentCategoryBarDelegate({
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: LodgingCategoryBar(
        selectedCategory: selectedCategory ?? LodgingCategory.defaultCategory,
        onCategoryChanged: onCategoryChanged,
      ),
    );
  }

  @override
  double get maxExtent => 56.0; // 카테고리 바의 전체 높이 (margin 포함)

  @override
  double get minExtent => 56.0; // 최소 높이도 동일하게 설정

  @override
  bool shouldRebuild(covariant PersistentCategoryBarDelegate oldDelegate) {
    return selectedCategory != oldDelegate.selectedCategory;
  }
}
