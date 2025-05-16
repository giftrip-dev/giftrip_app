import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/features/shopping/models/shopping_category.dart';
import 'package:giftrip/features/shopping/widgets/shopping_category_bar.dart';

class PersistentCategoryBarDelegate extends SliverPersistentHeaderDelegate {
  final ShoppingCategory? selectedCategory;
  final Function(ShoppingCategory?) onCategoryChanged;

  PersistentCategoryBarDelegate({
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 8),
          ShoppingCategoryBar(
            selectedCategory: selectedCategory,
            onCategoryChanged: onCategoryChanged,
          ),
          const SizedBox(height: 8),
          Container(
            height: 1,
            color: AppColors.gray300,
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(PersistentCategoryBarDelegate oldDelegate) {
    return oldDelegate.selectedCategory != selectedCategory;
  }
}
