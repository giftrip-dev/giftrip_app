import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/utils/formatter.dart';

/// 할인율과 원래 가격을 표시하는 위젯
class DiscountRateText extends StatelessWidget {
  final int discountRate;
  final int originalPrice;

  const DiscountRateText({
    super.key,
    required this.discountRate,
    required this.originalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
