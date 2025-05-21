import 'package:flutter/material.dart';
import 'package:giftrip/features/reservation/models/reservation_category.dart';
import 'package:giftrip/features/reservation/widgets/reservation_category_bar.dart';

class PersistentCategoryBarDelegate extends SliverPersistentHeaderDelegate {
  final ReservationCategory? selectedCategory;
  final Function(ReservationCategory?) onCategoryChanged;
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
      padding: const EdgeInsets.only(top: 16),
      color: Colors.white,
      child: ReservationCategoryBar(
        selectedCategory: selectedCategory,
        onCategoryChanged: onCategoryChanged,
        totalCount: totalCount,
      ),
    );
  }

  @override
  double get maxExtent => 56;

  @override
  double get minExtent => 56;

  @override
  bool shouldRebuild(covariant PersistentCategoryBarDelegate oldDelegate) {
    return selectedCategory != oldDelegate.selectedCategory ||
        totalCount != oldDelegate.totalCount;
  }
}
