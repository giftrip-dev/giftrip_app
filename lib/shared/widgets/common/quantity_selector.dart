import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/input/quantity_input.dart';
import 'package:giftrip/core/widgets/text/price_text.dart';

class QuantitySelector extends StatelessWidget {
  final String productName;
  final int price;
  final int quantity;
  final Function(int) onQuantityChanged;

  const QuantitySelector({
    super.key,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundAlternative,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상품명
          Text(
            productName,
            style: body_M,
          ),
          const SizedBox(height: 12),

          // 수량 선택기와 가격
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 수량 선택기
              QuantityInput(
                quantity: quantity,
                onChanged: onQuantityChanged,
                width: 120,
              ),

              // 가격
              PriceText(price: price * quantity),
            ],
          ),
        ],
      ),
    );
  }
}
