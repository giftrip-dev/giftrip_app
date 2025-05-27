import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/rating/star_rating.dart';

class RatingDisplay extends StatelessWidget {
  final double rating;
  final double starSize;
  final Color starColor;
  final double starSpacing;
  final bool showHalfStars;
  final bool showRatingText;
  final TextStyle? ratingTextStyle;
  final double spaceBetween;

  const RatingDisplay({
    super.key,
    required this.rating,
    this.starSize = 16.0,
    this.starColor = AppColors.primarySoft,
    this.starSpacing = 2.0,
    this.showHalfStars = true,
    this.showRatingText = true,
    this.ratingTextStyle,
    this.spaceBetween = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StarRating(
          rating: rating,
          size: starSize,
          color: starColor,
          spacing: starSpacing,
          showHalfStars: showHalfStars,
        ),
        if (showRatingText) ...[
          SizedBox(width: spaceBetween),
          Text(
            rating.toStringAsFixed(1),
            style: ratingTextStyle ??
                subtitle_S.copyWith(color: AppColors.labelStrong),
          ),
        ],
      ],
    );
  }
}
