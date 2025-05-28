import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/core/widgets/image/custom_image.dart';
import 'package:giftrip/core/widgets/text/price_text.dart';

class ProductItemRow extends StatelessWidget {
  final String thumbnailUrl;
  final String title;
  final int quantity;
  final int price;
  final ProductItemType type;

  const ProductItemRow({
    super.key,
    required this.thumbnailUrl,
    required this.title,
    required this.quantity,
    required this.price,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 상품 썸네일
        CustomImage(
          imageUrl: thumbnailUrl,
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
                type == ProductItemType.product
                    ? '$title, ${quantity}개'
                    : title,
                style: body_S,
              ),
              const SizedBox(height: 4),
              PriceText(
                price: price,
                color: AppColors.labelStrong,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
