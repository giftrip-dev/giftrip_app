import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/features/order_history/widgets/order_history_category_bar.dart';

class PersistentCategoryBarDelegate extends SliverPersistentHeaderDelegate {
  final ProductItemType? selectedCategory;
  final Function(ProductItemType?) onCategoryChanged;
  final int totalCount;

  PersistentCategoryBarDelegate({
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.totalCount,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 0),
      color: Colors.white,
      child: OrderHistoryCategoryBar(
        selectedCategory: selectedCategory,
        onCategoryChanged: onCategoryChanged,
        totalCount: totalCount,
      ),
    );
  }

  @override
  double get maxExtent => 45;

  @override
  double get minExtent => 45;

  @override
  bool shouldRebuild(covariant PersistentCategoryBarDelegate oldDelegate) {
    return selectedCategory != oldDelegate.selectedCategory ||
        totalCount != oldDelegate.totalCount;
  }
}
