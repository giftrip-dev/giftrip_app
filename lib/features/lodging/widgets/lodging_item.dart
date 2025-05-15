import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/utils/formatter.dart';
import 'package:giftrip/core/widgets/image/custom_image.dart';
import 'package:giftrip/features/lodging/models/lodging_model.dart';
import 'package:giftrip/features/lodging/screens/lodging_detail_screen.dart';
import 'package:giftrip/features/home/widgets/product/item_badge.dart';

class LodgingItem extends StatelessWidget {
  final LodgingModel lodging;
  final double imageSize;
  const LodgingItem({
    super.key,
    required this.lodging,
    required this.imageSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LodgingDetailScreen(
              lodgingId: lodging.id,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 썸네일
          CustomImage(
            imageUrl: lodging.thumbnailUrl,
            width: imageSize,
            height: imageSize,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),

          // 2. 제목
          SizedBox(
            child: Text(
              lodging.title,
              style: body_S,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),

          // 3. 가격 및 할인율
          if (lodging.hasDiscount) ...[
            Row(
              children: [
                Text(
                  '${lodging.discountRate}%',
                  style: subtitle_XS.copyWith(
                    color: AppColors.statusError,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${formatPrice(lodging.originalPrice)}원',
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
            '${formatPrice(lodging.finalPrice)}원',
            style: title_L,
          ),

          const SizedBox(height: 8),

          // 5. 뱃지들
          if (lodging.badges.isNotEmpty)
            Row(
              children: [
                for (var i = 0; i < lodging.badges.length; i++) ...[
                  if (i > 0) const SizedBox(width: 4),
                  ItemBadge(type: lodging.badges[i]),
                ],
              ],
            ),
        ],
      ),
    );
  }
}
