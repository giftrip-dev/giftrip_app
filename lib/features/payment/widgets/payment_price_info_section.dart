import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/utils/formatter.dart';

class PaymentPriceInfoSection extends StatelessWidget {
  final int totalProductPrice;
  final int shippingFee;
  final int finalPrice;

  const PaymentPriceInfoSection({
    super.key,
    required this.totalProductPrice,
    required this.shippingFee,
    required this.finalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          // 총 상품 금액
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('총 상품 금액', style: body_M),
              Text(
                '${formatPrice(totalProductPrice)}원',
                style: body_M.copyWith(color: AppColors.labelStrong),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 배송비
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('배송비', style: body_M),
              Text(
                '${formatPrice(shippingFee)}원',
                style: body_M.copyWith(color: AppColors.labelStrong),
              ),
            ],
          ),
          const Divider(height: 24),

          // 최종 결제 금액
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('최종 결제 금액', style: title_S),
              Text(
                '${formatPrice(finalPrice)}원',
                style: title_S.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
