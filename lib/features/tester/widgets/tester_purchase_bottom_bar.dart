import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/utils/formatter.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/features/tester/widgets/tester_purchase_bottom_sheet.dart';

class TesterPurchaseBottomBar extends StatelessWidget {
  final int originalPrice;
  final int finalPrice;
  final int? discountRate;
  final bool soldOut;

  const TesterPurchaseBottomBar({
    super.key,
    required this.originalPrice,
    required this.finalPrice,
    this.discountRate,
    this.soldOut = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.line, width: 1),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // 가격 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 할인율과 원가 (할인이 있는 경우만)
                  if (discountRate != null && discountRate! > 0) ...[
                    Row(
                      children: [
                        Text(
                          '$discountRate%',
                          style: subtitle_XS.copyWith(
                            color: AppColors.statusError,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${formatPrice(originalPrice)}원',
                          style: caption.copyWith(
                            color: AppColors.labelAlternative,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                  ],
                  // 최종 가격
                  Text(
                    '${formatPrice(finalPrice)}원',
                    style: title_L.copyWith(
                      color: soldOut ? AppColors.labelAlternative : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // 예약 버튼
            SizedBox(
              width: 120,
              child: CTAButton(
                text: soldOut ? '품절' : '예약하기',
                onPressed: soldOut
                    ? null
                    : () {
                        TesterPurchaseBottomSheet.show(context);
                      },
                isEnabled: !soldOut,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
