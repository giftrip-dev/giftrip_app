import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';

class CTAButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback? onPressed;
  final String text;
  final TextStyle? textStyle;

  const CTAButton({
    Key? key,
    required this.isEnabled,
    required this.onPressed,
    required this.text,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: AppColors.componentNatural,
          backgroundColor: AppColors.primaryStrong,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isEnabled
            ? Text(text,
                style: textStyle ??
                    subtitle_L.copyWith(color: AppColors.labelWhite))
            : Text(text,
                style: textStyle ??
                    subtitle_L.copyWith(color: AppColors.labelAlternative)),
      ),
    );
  }
}
