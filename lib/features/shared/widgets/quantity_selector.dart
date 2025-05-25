import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/utils/formatter.dart';
import 'package:giftrip/core/widgets/text/price_text.dart';
import 'package:lucide_icons/lucide_icons.dart';

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
              Container(
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.gray400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 마이너스 버튼
                    IconButton(
                      onPressed: quantity > 1
                          ? () => onQuantityChanged(quantity - 1)
                          : null,
                      icon: Icon(
                        LucideIcons.minus,
                        size: 20,
                        color: quantity > 1
                            ? AppColors.label
                            : AppColors.labelAlternative,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    // 수량 표시
                    Text(
                      quantity.toString(),
                      style: title_S,
                    ),
                    SizedBox(
                      width: 12,
                    ),

                    // 플러스 버튼
                    IconButton(
                      onPressed: () => onQuantityChanged(quantity + 1),
                      icon: const Icon(
                        LucideIcons.plus,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),
              ),

              // 가격
              PriceText(price: price),
            ],
          ),
        ],
      ),
    );
  }
}
