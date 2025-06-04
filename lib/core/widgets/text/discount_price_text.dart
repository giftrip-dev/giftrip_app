import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/utils/formatter.dart';

/// 할인된 가격과 원래 가격을 함께 표시하는 위젯
class DiscountPriceText extends StatelessWidget {
  final int originalPrice;
  final int finalPrice;
  final int discountRate;

  const DiscountPriceText({
    super.key,
    required this.originalPrice,
    required this.finalPrice,
    required this.discountRate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (discountRate > 0) ...[
          Row(
            children: [
              Text(
                '$discountRate%',
                style: subtitle_XS.copyWith(
                  color: AppColors.statusError,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${formatPrice(originalPrice)}원',
                style: caption.copyWith(
                  color: AppColors.labelAlternative,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: AppColors.labelAlternative,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
        ],
        Text(
          '${formatPrice(finalPrice)}원',
          style: title_L,
        ),
      ],
    );
  }
}
