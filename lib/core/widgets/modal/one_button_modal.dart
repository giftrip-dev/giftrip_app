import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';

class OneButtonModal extends StatelessWidget {
  final String title;
  final String? desc;
  final VoidCallback onConfirm;

  const OneButtonModal({
    super.key,
    required this.title,
    this.desc,
    required this.onConfirm,
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
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(title, style: title_L, textAlign: TextAlign.center),
                  if (desc != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      desc!,
                      style: subtitle_S.copyWith(color: AppColors.labelNatural),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),

            // ✅ 하단 버튼 섹션
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.line),
                ),
              ),
              child: TextButton(
                onPressed: onConfirm,
                style: TextButton.styleFrom(
                  minimumSize: Size(double.infinity, 0),
                  padding: const EdgeInsets.symmetric(vertical: 13.5),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                ),
                child: Text(
                  "확인",
                  style: title_S.copyWith(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
