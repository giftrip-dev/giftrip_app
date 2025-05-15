import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';

class OneButtonModal extends StatelessWidget {
  final String title;
  final String? desc;
  final VoidCallback onConfirm;
  final EdgeInsetsGeometry contentPadding;

  const OneButtonModal({
    super.key,
    required this.title,
    this.desc,
    required this.onConfirm,
    this.contentPadding = const EdgeInsets.only(bottom: 24, top: 32),
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color:
                  const Color(0xFFD6D6D6).withOpacity(0.7), // ✅ #D6D6D6 색상 적용
              offset: const Offset(0, 4),
              blurRadius: 18, // 흐림 정도
              spreadRadius: 0, // 확산 정도
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ 상단 섹션
            Padding(
              padding: contentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(title, style: title_L, textAlign: TextAlign.center),
                  if (desc != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      desc!,
                      style: body_S.copyWith(color: AppColors.labelNatural),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),

            // ✅ 하단 버튼 섹션
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: CTAButton(
                onPressed: onConfirm,
                text: "확인",
                isEnabled: true,
                textStyle: title_S.copyWith(color: AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
