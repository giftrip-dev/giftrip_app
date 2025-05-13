import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';

Future commonModal({
  required BuildContext context,
  String? title,
  String? desc,
  String? buttonText,
  VoidCallback? onConfirm,
  Widget? titleWidget,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 328),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                if (titleWidget != null)
                  titleWidget
                else if (title != null)
                  Text(
                    title,
                    style: h2_S.copyWith(color: AppColors.label),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 8),
                // Description
                if (desc != null)
                  Text(
                    desc,
                    style: body_M.copyWith(color: AppColors.label),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 24),
                // Buttons
                Row(
                  children: [
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          onPressed: onConfirm ?? () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: AppColors.primary,
                            elevation: 0,
                          ),
                          child: Text(
                            buttonText ?? "확인",
                            style: h2_S.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
