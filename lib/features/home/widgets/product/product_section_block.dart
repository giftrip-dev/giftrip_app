import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/widgets/section_divider.dart';
import 'package:myong/features/home/view_models/product_view_model.dart';
import 'package:myong/features/home/widgets/product/product_carousel.dart';

/// 단일 상품 섹션(제목+부제목+캐러셀) UI
class ProductSectionBlock extends StatelessWidget {
  final String subtitle;
  final String title;
  final ProductSection section;
  final bool hideBottomDivider;
  const ProductSectionBlock({
    super.key,
    required this.subtitle,
    required this.title,
    required this.section,
    this.hideBottomDivider = false,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subtitle, style: body_M),
                const SizedBox(height: 4),
                Text(title,
                    style: title_L.copyWith(color: AppColors.labelStrong)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ProductCarousel(section: section),
          const SizedBox(height: 24),
          if (!hideBottomDivider) const SectionDivider(),
        ],
      );
}
