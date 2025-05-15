import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    Key? key,
    required String message,
    IconData? icon,
    Color? iconColor = AppColors.white,
    double? iconSize = 24,
    Color backgroundColor = AppColors.toastBackground,
    Color textColor = AppColors.toastLabel,
    double borderRadius = 12,
    Duration duration = const Duration(seconds: 2),
    TextStyle? textStyle,
  }) : super(
          key: key,
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          duration: duration,
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: iconColor, size: iconSize),
                  const SizedBox(width: 12),
                ],
                Flexible(
                  child: Text(
                    message,
                    style: textStyle ?? title_S.copyWith(color: textColor),
                  ),
                ),
              ],
            ),
          ),
        );
}
