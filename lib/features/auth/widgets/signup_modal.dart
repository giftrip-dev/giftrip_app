import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';

Future signupModal({
  required BuildContext context,
  String? description,
  required VoidCallback onConfirm,
  required String confirmButtonText,
  String? titleText,
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
                else if (titleText != null)
                  Text(
                    titleText,
                    style: h2_S.copyWith(color: AppColors.label),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 8),
                // Description
                if (description != null)
                  Text(
                    description,
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
                          onPressed: onConfirm,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: AppColors.primary,
                            elevation: 0,
                          ),
                          child: Text(
                            confirmButtonText,
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
