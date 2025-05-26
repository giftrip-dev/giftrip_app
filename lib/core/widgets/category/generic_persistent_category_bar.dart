import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/category/generic_category_bar.dart';

/// 제네릭 고정 카테고리 바 Delegate
class GenericPersistentCategoryBarDelegate<T extends Enum>
    extends SliverPersistentHeaderDelegate {
  final T? selectedCategory;
  final Function(T?) onCategoryChanged;
  final List<T> categories;
  final String Function(T) getLabelFunc;
  final int Function(T?)? getCountFunc;

  GenericPersistentCategoryBarDelegate({
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.categories,
    required this.getLabelFunc,
    this.getCountFunc,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          const SizedBox(height: 6),
          GenericCategoryBar<T>(
            selectedCategory: selectedCategory,
            onCategoryChanged: onCategoryChanged,
            categories: categories,
            getLabelFunc: getLabelFunc,
            getCountFunc: getCountFunc,
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(GenericPersistentCategoryBarDelegate<T> oldDelegate) {
    return selectedCategory != oldDelegate.selectedCategory;
  }
}
