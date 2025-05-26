import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/core/widgets/image/custom_image.dart';
import 'package:giftrip/core/widgets/input/quantity_input.dart';
import 'package:giftrip/features/cart/models/cart_item_model.dart';
import 'package:giftrip/features/cart/models/cart_category.dart';
import 'package:giftrip/features/home/models/product_model.dart';
import 'package:giftrip/features/home/widgets/product/item_badge.dart';
import 'package:intl/intl.dart';

class CartItemReservation extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback? onDetailTap;
  final bool isSelected;
  final VoidCallback? onSelect;
  final VoidCallback? onDelete;
  final ValueChanged<int>? onQuantityChanged;

  const CartItemReservation({
    super.key,
    required this.item,
    this.onDetailTap,
    this.isSelected = false,
    this.onSelect,
    this.onDelete,
    this.onQuantityChanged,
  });

  bool get _isExperience =>
      item.category == CartCategory.experience ||
      item.category == CartCategory.experienceGroup;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy.MM.dd (E)', 'ko_KR');
    final formatter = NumberFormat('#,###');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.line, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 타이틀 + 체크박스
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
                        onTap: onSelect,
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
                    // 날짜/옵션
                    Text(
                      _reservationSubText(dateFormat),
                      style: caption.copyWith(color: AppColors.labelNatural),
                    ),
                    if (item.category == CartCategory.lodging) ...[
                      const SizedBox(height: 2),
                      _buildLodgingInfoRow(),
                      _buildPersonInfoRow(),
                      const SizedBox(height: 4),
                    ],
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
                    // 체험 수량 조절
                    if (_isExperience) ...[
                      const SizedBox(height: 10),
                      QuantityInput(
                        quantity: item.quantity ?? 1,
                        onChanged: onQuantityChanged,
                        width: 120,
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

  String _reservationSubText(DateFormat dateFormat) {
    // 숙소인 경우
    if (item.category == CartCategory.lodging) {
      if (item.startDate != null && item.endDate != null) {
        return '${dateFormat.format(item.startDate!)} ~ ${dateFormat.format(item.endDate!)}';
      }
      return '';
    } else {
      if (item.startDate != null) {
        if (item.type == ProductItemType.experience) {
          // 체험인 경우 시작일 ~ 종료일 표시
          if (item.endDate != null) {
            return '${dateFormat.format(item.startDate!)} ~ ${dateFormat.format(item.endDate!)}';
          }
        } else {
          // 체험단인 경우 시작일만 표시
          return dateFormat.format(item.startDate!);
        }
      }
      return '';
    }
  }

  Widget _buildLodgingInfoRow() {
    return Row(
      children: [
        if (item.checkInTime?.isNotEmpty ?? false)
          Text('체크인 ${item.checkInTime}',
              style: caption.copyWith(color: AppColors.labelNatural)),
        if ((item.checkInTime?.isNotEmpty ?? false) &&
            (item.checkOutTime?.isNotEmpty ?? false))
          Text('  |  ', style: caption.copyWith(color: AppColors.labelNatural)),
        if (item.checkOutTime?.isNotEmpty ?? false)
          Text('체크아웃 ${item.checkOutTime}',
              style: caption.copyWith(color: AppColors.labelNatural)),
      ],
    );
  }

  Widget _buildPersonInfoRow() {
    return Row(
      children: [
        if (item.standardPerson != null)
          Text('기준 ${item.standardPerson}명',
              style: caption.copyWith(color: AppColors.labelNatural)),
        if (item.standardPerson != null && item.maxPerson != null)
          Text('  |  ', style: caption.copyWith(color: AppColors.labelNatural)),
        if (item.maxPerson != null)
          Text('최대 ${item.maxPerson}명',
              style: caption.copyWith(color: AppColors.labelNatural)),
      ],
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
