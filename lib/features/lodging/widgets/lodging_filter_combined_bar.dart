import 'package:flutter/material.dart';
import 'lodging_filter_bar.dart';
import 'package:giftrip/features/lodging/models/lodging_category.dart';
import 'package:giftrip/features/lodging/widgets/lodging_category_bar.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LodgingFilterCombinedBar extends StatelessWidget {
  final String locationText;
  final VoidCallback? onLocationTap;
  final String stayOptionText;
  final VoidCallback? onStayOptionTap;

  const LodgingFilterCombinedBar({
    super.key,
    required this.locationText,
    this.onLocationTap,
    required this.stayOptionText,
    this.onStayOptionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LodgingFilterBar(
          icon: LucideIcons.mapPin,
          text: locationText,
          onTap: onLocationTap,
        ),
        const SizedBox(height: 8),
        LodgingFilterBar(
          icon: LucideIcons.calendarDays,
          text: stayOptionText,
          onTap: onStayOptionTap,
        ),
      ],
    );
  }
}

class LodgingFilterCombinedBarDelegate extends SliverPersistentHeaderDelegate {
  final String locationText;
  final VoidCallback? onLocationTap;
  final String stayOptionText;
  final VoidCallback? onStayOptionTap;
  final LodgingCategory? selectedCategory;
  final Function(LodgingCategory?) onCategoryChanged;

  LodgingFilterCombinedBarDelegate({
    required this.locationText,
    this.onLocationTap,
    required this.stayOptionText,
    this.onStayOptionTap,
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
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: LodgingFilterCombinedBar(
              locationText: locationText,
              onLocationTap: onLocationTap,
              stayOptionText: stayOptionText,
              onStayOptionTap: onStayOptionTap,
            ),
          ),
          LodgingCategoryBar(
            selectedCategory:
                selectedCategory ?? LodgingCategory.defaultCategory,
            onCategoryChanged: onCategoryChanged,
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 98.0 + 45.0 + 16.0; // 두 바 높이 합산 (적절히 조정)

  @override
  double get minExtent => 98.0 + 45.0 + 16.0;

  @override
  bool shouldRebuild(covariant LodgingFilterCombinedBarDelegate oldDelegate) {
    return locationText != oldDelegate.locationText ||
        stayOptionText != oldDelegate.stayOptionText ||
        selectedCategory != oldDelegate.selectedCategory;
  }
}

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
  double get maxExtent => 156.0; // 카테고리 바의 전체 높이 (margin 포함)

  @override
  double get minExtent => 156.0; // 최소 높이도 동일하게 설정

  @override
  bool shouldRebuild(covariant PersistentCategoryBarDelegate oldDelegate) {
    return selectedCategory != oldDelegate.selectedCategory;
  }
}
