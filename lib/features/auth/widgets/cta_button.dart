import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';

class CTAButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? buttonText;
  final bool? disabled;
  final TextStyle? textStyle;
  const CTAButton({
    Key? key,
    required this.onPressed,
    this.buttonText,
    this.disabled,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: disabled == true ? AppColors.line : AppColors.primary,
        minimumSize: const Size(double.infinity, 51),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onPressed: disabled == true ? null : onPressed,
      child: Text(
        buttonText ?? '다음',
        style: textStyle ??
            h2_S.copyWith(
                color: disabled == true
                    ? AppColors.labelAlternative
                    : Colors.white),
      ),
    );
  }
}
