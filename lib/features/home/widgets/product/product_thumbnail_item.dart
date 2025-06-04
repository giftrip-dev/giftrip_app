import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/image/custom_image.dart';
import 'package:giftrip/core/widgets/text/price_text.dart';
import 'package:giftrip/core/widgets/text/discount_rate_text.dart';
import 'package:giftrip/features/home/models/product_model.dart';
import 'package:giftrip/features/home/widgets/product/item_badge.dart';

/// 상품 썸네일 아이템 위젯
class ProductThumbnailItem extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductThumbnailItem({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 156,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 썸네일 이미지
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomImage(
                imageUrl: product.thumbnailUrl ?? '',
                width: 156,
                height: 145,
                fit: BoxFit.cover,
              ),
            ),

            // 상품 정보
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상품명
                  Text(
                    product.title,
                    style: body_M,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // 가격 정보
                  const SizedBox(height: 8),
                  if (product.discountRate > 0) ...[
                    DiscountRateText(
                      discountRate: product.discountRate,
                      originalPrice: product.originalPrice,
                    ),
                    const SizedBox(height: 2),
                  ],
                  PriceText(
                    price: product.finalPrice,
                    color: AppColors.labelStrong,
                  ),
                  const SizedBox(height: 8),

                  // 뱃지들 (NEW, BEST 등)
                  if (product.itemTags.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: product.itemTags
                            .map((tag) => ItemBadge(tag: tag))
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
