import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/utils/formatter.dart';
import 'package:myong/core/widgets/image/custom_image.dart';
import 'package:myong/features/experience/models/experience_model.dart';
import 'package:myong/features/home/models/product_model.dart';
import 'package:myong/features/home/widgets/product/item_badge.dart';

class ExperienceItem extends StatelessWidget {
  final ExperienceModel experience;
  final ItemBadgeType badgeType;
  final double imageSize;

  const ExperienceItem({
    super.key,
    required this.experience,
    required this.badgeType,
    required this.imageSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 썸네일
        CustomImage(
          imageUrl: experience.thumbnailUrl,
          width: imageSize,
          height: imageSize,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 8),

        // 2. 제목
        SizedBox(
          child: Text(
            experience.title,
            style: body_M,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 8),

        // 3. 가격 및 할인율
        if (experience.hasDiscount) ...[
          Row(
            children: [
              Text(
                '${experience.discountRate}%',
                style: subtitle_XS.copyWith(
                  color: AppColors.statusError,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${formatPrice(experience.originalPrice)}원',
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
          '${formatPrice(experience.finalPrice)}원',
          style: title_L,
        ),

        const SizedBox(height: 8),

        // 5. 뱃지
        ItemBadge(type: badgeType),
      ],
    );
  }
}
