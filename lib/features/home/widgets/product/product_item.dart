import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/utils/formatter.dart';
import 'package:myong/core/widgets/image/custom_image.dart';
import 'package:myong/features/home/models/product_model.dart';
import 'package:myong/features/home/widgets/product/item_badge.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;
  final ItemBadgeType badgeType;

  const ProductItem({
    super.key,
    required this.product,
    required this.badgeType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 썸네일
        CustomImage(
          imageUrl: product.thumbnailUrl,
          width: 156,
          height: 145,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 8),

        // 2. 제목
        SizedBox(
          // height: 44,
          child: Text(
            product.title,
            style: body_S,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 8),

        // 3. 가격 및 할인율
        if (product.hasDiscount) ...[
          Row(
            children: [
              Text(
                '${product.discountRate}%',
                style: subtitle_XS.copyWith(
                  color: AppColors.statusError,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${formatPrice(product.originalPrice)}원',
                style: caption.copyWith(
                  color: AppColors.labelAlternative,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
        ],

        // 4. 최종 가격
        Text(
          '${formatPrice(product.finalPrice)}원',
          style: title_L,
        ),

        const SizedBox(height: 8),

        // 5. 뱃지
        ItemBadge(type: badgeType),
      ],
    );
  }
}
