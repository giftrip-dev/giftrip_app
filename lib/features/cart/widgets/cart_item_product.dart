import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/image/custom_image.dart';
import 'package:giftrip/core/widgets/input/quantity_input.dart';
import 'package:giftrip/features/cart/models/cart_item_model.dart';
import 'package:giftrip/features/home/models/product_model.dart';
import 'package:giftrip/features/home/widgets/product/item_badge.dart';
import 'package:intl/intl.dart';

class CartItemProduct extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback? onDetailTap;
  final VoidCallback? onTitleTap;
  final bool isSelected;
  final VoidCallback? onSelect;
  final VoidCallback? onDelete;
  final ValueChanged<int>? onQuantityChanged;

  const CartItemProduct({
    super.key,
    required this.item,
    this.onDetailTap,
    this.onTitleTap,
    this.isSelected = false,
    this.onSelect,
    this.onDelete,
    this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.line, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 타이틀 + 체크박스
          Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  fillColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return AppColors.primaryStrong;
                    }
                    return AppColors.white;
                  }),
                  checkColor: AppColors.white,
                  activeColor: AppColors.primaryStrong,
                  value: isSelected,
                  onChanged: (_) => onSelect?.call(),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  side: BorderSide(color: AppColors.lineNatural, width: 1),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onTitleTap,
                        child: Text(
                          item.title,
                          style:
                              subtitle_M.copyWith(color: AppColors.labelStrong),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onDelete,
                      child: Text('삭제',
                          style: body_S.copyWith(
                              color: AppColors.labelAlternative)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 본문
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomImage(
                imageUrl: item.thumbnailUrl,
                width: 60,
                height: 60,
                borderRadius: BorderRadius.circular(4),
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 옵션
                    if (item.options != null && item.options!.isNotEmpty)
                      Text(item.options!,
                          style:
                              caption.copyWith(color: AppColors.labelNatural)),
                    const SizedBox(height: 4),
                    // 할인/가격
                    _buildPriceBlock(formatter),
                    // 태그
                    if (item.tags.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          for (final tag in item.tags)
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: ItemBadge(
                                type: ProductTagType.values
                                    .firstWhere((e) => e.name == tag),
                              ),
                            ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 10),
                    // 수량 조절
                    QuantityInput(
                      quantity: item.quantity ?? 1,
                      onChanged: onQuantityChanged,
                      width: 120,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBlock(NumberFormat formatter) {
    final hasDiscount = item.discountRate != null && item.discountRate! > 0;

    // 수량을 고려한 가격 계산
    final quantity = item.quantity ?? 1;
    final totalPrice = item.price * quantity;
    final totalOriginalPrice = item.originalPrice * quantity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasDiscount) ...[
          Row(
            children: [
              Text('${item.discountRate}% ',
                  style: subtitle_XS.copyWith(color: AppColors.statusError)),
              const SizedBox(width: 4),
              Text(
                formatter.format(totalOriginalPrice),
                style: caption.copyWith(
                  color: AppColors.labelAlternative,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: AppColors.labelAlternative,
                ),
              ),
            ],
          ),
        ],
        Text('${formatter.format(totalPrice)}원',
            style: title_L.copyWith(color: AppColors.labelStrong)),
      ],
    );
  }
}
