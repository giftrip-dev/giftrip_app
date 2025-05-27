import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;
  final double spacing;
  final bool showHalfStars;

  const StarRating({
    super.key,
    required this.rating,
    this.size = 16.0,
    this.color = AppColors.primarySoft,
    this.spacing = 2.0,
    this.showHalfStars = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        IconData iconData;

        if (showHalfStars) {
          // 반별 지원
          if (index < rating.floor()) {
            iconData = Icons.star;
          } else if (index < rating) {
            iconData = Icons.star_half;
          } else {
            iconData = Icons.star_border;
          }
        } else {
          // 정수별만 지원
          iconData = index < rating.toInt() ? Icons.star : Icons.star_border;
        }

        return Padding(
          padding: EdgeInsets.only(
            right: index < 4 ? spacing : 0,
          ),
          child: Icon(
            iconData,
            color: color,
            size: size,
          ),
        );
      }),
    );
  }
}
