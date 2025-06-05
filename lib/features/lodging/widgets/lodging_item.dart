import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/utils/formatter.dart';
import 'package:giftrip/core/widgets/image/custom_image.dart';
import 'package:giftrip/features/lodging/models/lodging_model.dart';
import 'package:giftrip/features/lodging/screens/lodging_detail_screen.dart';
import 'package:giftrip/features/home/widgets/product/item_badge.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LodgingItem extends StatelessWidget {
  final LodgingModel lodging;
  final double width;
  final double height;
  const LodgingItem({
    super.key,
    required this.lodging,
    required this.width,
    required this.height,
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
            width: width,
            height: height,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 12),

          // 2. 제목
          SizedBox(
            child: Text(
              lodging.name,
              style: title_L,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          // 3. 위치
          SizedBox(
            child: Row(
              children: [
                Icon(
                  LucideIcons.mapPin,
                  size: 18,
                  color: AppColors.label,
                ),
                const SizedBox(width: 8),
                Text(
                  lodging.address1,
                  style: body_S.copyWith(
                    color: AppColors.label,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // 5. 뱃지들
          // if (lodging.category.isNotEmpty)
          //   Row(
          //     children: [
          //       for (var i = 0; i < lodging.category.length; i++) ...[
          //         if (i > 0) const SizedBox(width: 4),
          //         ItemBadge(tag: lodging.category),
          //       ],
          //     ],
          //   ),
          const SizedBox(height: 12),
          // 6. 가격 및 할인율
          if (lodging.cheapestDiscountRate > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${lodging.cheapestDiscountRate}%',
                  style: subtitle_XS.copyWith(
                    color: AppColors.labelAlternative,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${formatPrice(lodging.cheapestOriginalPrice)}원',
                  style: caption.copyWith(
                    color: AppColors.labelAlternative,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ],

          // 7. 최종 가격
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${formatPrice(lodging.cheapestFinalPrice)}원',
              style: title_L,
            ),
          ),
        ],
      ),
    );
  }
}
