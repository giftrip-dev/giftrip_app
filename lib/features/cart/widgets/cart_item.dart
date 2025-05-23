import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/features/cart/models/cart_item_model.dart';
import 'package:intl/intl.dart';
import 'package:giftrip/features/cart/models/cart_category.dart';

class CartItem extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback? onDetailTap;
  final bool isSelected;
  final VoidCallback? onSelect;
  final VoidCallback? onDelete;
  final ValueChanged<int>? onQuantityChanged;

  const CartItem({
    super.key,
    required this.item,
    this.onDetailTap,
    this.isSelected = false,
    this.onSelect,
    this.onDelete,
    this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy.MM.dd');
    final formatter = NumberFormat('#,###');
    final isExperience = item.category == CartCategory.experience ||
        item.category == CartCategory.experienceGroup;
    final isProduct = item.category == CartCategory.product;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.line, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  fillColor: WidgetStateProperty.all(AppColors.white),
                  activeColor: AppColors.primaryStrong,
                  value: isSelected,
                  onChanged: (_) => onSelect?.call(),
                  side: BorderSide(color: AppColors.lineNatural, width: 1),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: subtitle_M.copyWith(
                          color: AppColors.labelStrong,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onDelete,
                      child: Text(
                        '삭제',
                        style:
                            body_S.copyWith(color: AppColors.labelAlternative),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  item.thumbnailUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateFormat.format(item.addedAt),
                      style: caption.copyWith(
                        color: AppColors.labelNatural,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (item.discountRate != null &&
                            item.discountRate! > 0) ...[
                          Text(
                            '${item.discountRate}% ',
                            style: subtitle_XS.copyWith(
                                color: AppColors.statusError),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formatter.format(item.originalPrice),
                            style: caption.copyWith(
                              color: AppColors.labelAlternative,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: AppColors.labelAlternative,
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '${formatter.format(item.price)}원',
                      style: title_L.copyWith(color: AppColors.labelStrong),
                    ),
                    if (item.tags.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        children: item.tags
                            .map((tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.statusAlarm,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    tag,
                                    style: subtitle_XS.copyWith(
                                        color: AppColors.white),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                    if (isExperience || isProduct) ...[
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: AppColors.gray400, width: 1),
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.white,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (onQuantityChanged != null &&
                                    item.quantity > 1) {
                                  onQuantityChanged!(item.quantity - 1);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: const Icon(Icons.remove, size: 24),
                              ),
                            ),
                            Container(
                              width: 56,
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('${item.quantity}', style: heading_6),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (onQuantityChanged != null) {
                                  onQuantityChanged!(item.quantity + 1);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: const Icon(Icons.add, size: 24),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
