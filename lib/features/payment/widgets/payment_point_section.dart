import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/core/utils/formatter.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PaymentPointSection extends StatelessWidget {
  final TextEditingController pointController;
  final int availablePoint;
  final int totalPrice;
  final Function(String) onPointChanged;
  final VoidCallback onUseAllPoint;

  const PaymentPointSection({
    super.key,
    required this.pointController,
    required this.availablePoint,
    required this.totalPrice,
    required this.onPointChanged,
    required this.onUseAllPoint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 제목
        Row(
          children: [
            Text(
              '포인트 사용',
              style: title_M,
            ),
            const SizedBox(width: 8),
            Text(
              '${formatPrice(availablePoint)}P',
              style: body_M.copyWith(color: AppColors.statusError),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 포인트 입력 필드와 전액 사용 버튼
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: pointController,
                decoration: InputDecoration(
                  hintText: '0P',
                  hintStyle: TextStyle(color: AppColors.labelAssistive),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.line),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.line),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.line),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      LucideIcons.x,
                      size: 20,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      pointController.clear();
                      onPointChanged('0');
                    },
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: onPointChanged,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 100,
              child: CTAButton(
                onPressed: availablePoint > 0 ? onUseAllPoint : null,
                type: CTAButtonType.outline,
                size: CTAButtonSize.large,
                text: '전액 사용',
                isEnabled: availablePoint > 0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
