import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/utils/formatter.dart';
import 'package:giftrip/core/widgets/image/custom_image.dart';
import 'package:giftrip/features/payment/view_models/payment_view_model.dart';

class PaymentProductSection extends StatelessWidget {
  final List<PaymentItem> items;

  const PaymentProductSection({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 제목
        Text(
          '주문 상품 (${items.length})',
          style: title_M,
        ),
        const SizedBox(height: 12),

        // 상품 목록 컨테이너
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ...items.map((item) => _buildProductItem(item)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductItem(PaymentItem item) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: item == items.last ? 0 : 24,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상품 썸네일
          CustomImage(
            imageUrl: item.thumbnailUrl,
            width: 60,
            height: 60,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(width: 12),
          // 상품 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.title}, ${item.quantity}개',
                  style: body_S,
                ),
                const SizedBox(height: 4),
                Text(
                  '${formatPrice(item.price)}원',
                  style: title_M,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
