import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/utils/formatter.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/features/experience/widgets/experience_purchase_bottom_sheet.dart';

/// 체험 상품 구매 바텀바
class ExperiencePurchaseBottomBar extends StatelessWidget {
  final int originalPrice;
  final int finalPrice;
  final int? discountRate;
  final bool soldOut;
  final VoidCallback? onReserveTap;

  const ExperiencePurchaseBottomBar({
    super.key,
    required this.originalPrice,
    required this.finalPrice,
    this.discountRate,
    this.soldOut = false,
    this.onReserveTap,
  });

  /// 할인이 적용되었는지 여부
  bool get hasDiscount => discountRate != null && discountRate! > 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 가격 정보 (왼쪽)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 할인율 및 원가격 표시 (할인이 있는 경우만)
                  if (hasDiscount) ...[
                    Row(
                      children: [
                        Text(
                          '$discountRate%',
                          style: subtitle_S.copyWith(
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
                  ],

                  // 최종 가격
                  Text(
                    '${formatPrice(finalPrice)}원',
                    style: h1_R,
                  ),
                ],
              ),
            ),

            // 예약하기 버튼 (오른쪽)
            SizedBox(
              width: 128,
              child: CTAButton(
                text: soldOut ? '품절' : '예약하기',
                onPressed: () {
                  // 품절일 경우 아무 동작도 하지 않음
                  if (soldOut) return;

                  // 예약하기 바텀시트 표시
                  ExperiencePurchaseBottomSheet.show(context);

                  // 추가로 전달받은 콜백이 있으면 실행
                  if (onReserveTap != null) {
                    onReserveTap!();
                  }
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
