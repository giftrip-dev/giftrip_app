import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/features/reservation/models/reservation_category.dart';

class ReservationCategoryBar extends StatefulWidget {
  final ReservationCategory? selectedCategory;
  final Function(ReservationCategory?) onCategoryChanged;
  final int totalCount;

  const ReservationCategoryBar({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.totalCount,
  });

  @override
  State<ReservationCategoryBar> createState() => _ReservationCategoryBarState();
}

class _ReservationCategoryBarState extends State<ReservationCategoryBar> {
  final List<GlobalKey> _chipKeys = List.generate(
    ReservationCategory.values.length + 1, // +1 for '전체'
    (index) => GlobalKey(),
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = 32.0; // 좌우 패딩
    final availableWidth = screenWidth - horizontalPadding;
    final categoryCount = ReservationCategory.values.length + 1; // 전체 카테고리 포함
    final spacing = availableWidth / (categoryCount - 1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 전체 카테고리
          _CategoryChip(
            key: _chipKeys[0],
            label: '전체(${widget.totalCount})',
            isSelected: widget.selectedCategory == null,
            onTap: () => widget.onCategoryChanged(null),
          ),
          // 나머지 카테고리들
          ...ReservationCategory.values.asMap().entries.map((entry) {
            final idx = entry.key;
            final category = entry.value;
            return _CategoryChip(
              key: _chipKeys[idx + 1],
              label: category.label,
              isSelected: widget.selectedCategory == category,
              onTap: () => widget.onCategoryChanged(category),
            );
          }),
        ],
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
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

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
