import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/text/price_text.dart';
import 'package:giftrip/features/payment/view_models/payment_view_model.dart';

class PaymentPriceInfoSection extends StatelessWidget {
  final List<PaymentItem> items;
  final int shippingFee;
  final int finalPrice;

  const PaymentPriceInfoSection({
    super.key,
    required this.items,
    required this.shippingFee,
    required this.finalPrice,
  });

  int get totalProductPrice =>
      items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 제목
        Text(
          '결제 금액',
          style: title_M,
        ),
        const SizedBox(height: 16),

        // 개별 상품 목록
        ...items
            .asMap()
            .entries
            .map((e) => Padding(
                  padding: EdgeInsets.only(
                      bottom: e.key == items.length - 1 ? 0 : 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${e.value.title}, ${e.value.quantity}개',
                          style: body_M,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      PriceText(
                        price: e.value.price * e.value.quantity,
                        color: AppColors.labelStrong,
                      ),
                    ],
                  ),
                ))
            .toList(),

        // 배송비
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('배송비', style: body_M),
            PriceText(
              price: totalProductPrice < 30000 ? shippingFee : 0,
              color: AppColors.labelStrong,
            ),
          ],
        ),

        Divider(
          color: AppColors.line,
        ),

        // 최종 결제 금액
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('최종 결제 금액', style: body_M),
            PriceText(
              price: finalPrice,
              color: AppColors.labelStrong,
            ),
          ],
        ),
      ],
    );
  }
}
