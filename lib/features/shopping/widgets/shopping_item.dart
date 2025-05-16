import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/utils/formatter.dart';
import 'package:giftrip/core/widgets/image/custom_image.dart';
import 'package:giftrip/features/shopping/models/shopping_model.dart';
import 'package:giftrip/features/shopping/screens/shopping_detail_screen.dart';
import 'package:giftrip/features/home/models/product_model.dart';
import 'package:giftrip/features/home/widgets/product/item_badge.dart';

class ShoppingItem extends StatelessWidget {
  final ShoppingModel shopping;
  final double imageSize;
  const ShoppingItem({
    super.key,
    required this.shopping,
    required this.imageSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShoppingDetailScreen(
              shoppingId: shopping.id,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 썸네일
          Stack(
            children: [
              CustomImage(
                imageUrl: shopping.thumbnailUrl,
                width: imageSize,
                height: imageSize,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 2. 제목
          SizedBox(
            child: Text(
              shopping.title,
              style: body_S.copyWith(
                // 품절일 경우 텍스트 색상을 labelAlternative로 변경
                color: shopping.soldOut ? AppColors.labelAlternative : null,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),

          // 3. 가격 및 할인율
          if (shopping.hasDiscount) ...[
            Row(
              children: [
                Text(
                  '${shopping.discountRate}%',
                  style: subtitle_XS.copyWith(
                    color: AppColors.statusError,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${formatPrice(shopping.originalPrice)}원',
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
            '${formatPrice(shopping.finalPrice)}원',
            style: title_L.copyWith(
              // 품절일 경우 가격 텍스트 색상도 변경
              color: shopping.soldOut ? AppColors.labelAlternative : null,
            ),
          ),

          const SizedBox(height: 8),

          // 5. 뱃지들
          if (shopping.soldOut)
            // 품절인 경우 품절 뱃지만 표시
            const ItemBadge(type: ProductTagType.soldOut)
          else if (shopping.badges.isNotEmpty)
            // 품절이 아닌 경우 기존 뱃지 표시
            Row(
              children: [
                for (var i = 0; i < shopping.badges.length; i++) ...[
                  if (i > 0) const SizedBox(width: 4),
                  ItemBadge(type: shopping.badges[i]),
                ],
              ],
            ),
        ],
      ),
    );
  }
}
