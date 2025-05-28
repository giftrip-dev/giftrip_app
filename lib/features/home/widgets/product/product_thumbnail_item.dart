import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/utils/formatter.dart';
import 'package:giftrip/core/widgets/image/custom_image.dart';
import 'package:giftrip/features/home/models/product_model.dart';
import 'package:giftrip/features/home/widgets/product/item_badge.dart';
import 'package:giftrip/features/experience/screens/experience_detail_screen.dart';
import 'package:giftrip/features/lodging/screens/lodging_detail_screen.dart';
import 'package:giftrip/features/shopping/screens/shopping_detail_screen.dart';
import 'package:giftrip/features/tester/screens/tester_detail_screen.dart';

class ProductThumbnailItem extends StatelessWidget {
  final ProductModel product;
  final ProductTagType? badgeType;

  /// 홈 화면이 아닌 곳에서는 상품 자체의 배지를 사용하려면 true로 설정
  final bool useProductBadges;

  const ProductThumbnailItem({
    super.key,
    required this.product,
    this.badgeType,
    this.useProductBadges = false,
  }) : assert(badgeType != null || useProductBadges);

  void _onTap(BuildContext context) {
    switch (product.productType) {
      case ProductType.experience:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExperienceDetailScreen(
              experienceId: product.id,
            ),
          ),
        );
        break;
      case ProductType.experienceGroup:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TesterDetailScreen(
              testerId: product.id,
            ),
          ),
        );
        break;
      case ProductType.product:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShoppingDetailScreen(
              shoppingId: product.id,
            ),
          ),
        );
        break;
      case ProductType.lodging:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LodgingDetailScreen(
              lodgingId: product.id,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Column(
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

          // 5. 뱃지 (홈 화면에서는 섹션 배지, 다른 화면에서는 상품 자체 배지)
          if (useProductBadges && product.badges != null)
            ItemBadges(badges: product.badges!)
          else if (badgeType != null)
            ItemBadge(type: badgeType!),
        ],
      ),
    );
  }
}
