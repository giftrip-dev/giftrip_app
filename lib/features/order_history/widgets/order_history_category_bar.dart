import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/constants/item_type.dart';

class OrderHistoryCategoryBar extends StatefulWidget {
  final ProductItemType? selectedCategory;
  final Function(ProductItemType?) onCategoryChanged;
  final int totalCount;

  const OrderHistoryCategoryBar({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.totalCount,
  });

  @override
  State<OrderHistoryCategoryBar> createState() =>
      _OrderHistoryCategoryBarState();
}

class _OrderHistoryCategoryBarState extends State<OrderHistoryCategoryBar> {
  final List<GlobalKey> _chipKeys = List.generate(
    ProductItemType.values.length + 1, // +1 for '전체'
    (index) => GlobalKey(),
  );

  @override
  Widget build(BuildContext context) {
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
          ...ProductItemType.values.asMap().entries.map((entry) {
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
