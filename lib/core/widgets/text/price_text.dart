import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/utils/formatter.dart';

class PriceText extends StatelessWidget {
  final int price;
  final Color? color;

  const PriceText({
    super.key,
    required this.price,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final formattedPrice = formatPrice(price);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: formattedPrice,
            style: subtitle_M.copyWith(color: color),
          ),
          WidgetSpan(
            child: SizedBox(width: 1),
          ),
          TextSpan(
            text: '원',
            style: body_S.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
