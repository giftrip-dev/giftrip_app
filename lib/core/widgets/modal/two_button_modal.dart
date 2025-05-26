import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';

class TwoButtonModal extends StatelessWidget {
  final String title;
  final String? desc;
  final VoidCallback onConfirm;
  final String cancelText;
  final String confirmText;
  const TwoButtonModal({
    super.key,
    required this.title,
    this.desc,
    required this.onConfirm,
    this.cancelText = '취소',
    this.confirmText = '확인',
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
              color: const Color(0xFFD6D6D6).withOpacity(0.7),
              offset: const Offset(0, 4),
              blurRadius: 18,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
            const Divider(color: AppColors.line, height: 1),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13.5),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                    ),
                    child: Text(
                      cancelText,
                      style: title_M.copyWith(color: AppColors.labelNatural),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 48,
                  color: AppColors.line,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: onConfirm,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13.5),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                    ),
                    child: Text(
                      confirmText,
                      style: title_M.copyWith(color: AppColors.primaryStrong),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
