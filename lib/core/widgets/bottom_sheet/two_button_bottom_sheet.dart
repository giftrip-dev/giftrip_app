import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';

class TwoButtonBottomSheet extends StatelessWidget {
  final bool isEnabled;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final String buttonText2;
  final VoidCallback onButtonPressed2;
  final Color backgroundColor;
  const TwoButtonBottomSheet({
    Key? key,
    required this.isEnabled,
    required this.buttonText,
    required this.onButtonPressed,
    required this.buttonText2,
    required this.onButtonPressed2,
    this.backgroundColor = AppColors.background,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 60, top: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CTAButton(
            isEnabled: isEnabled,
            onPressed: onButtonPressed,
            text: buttonText,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onButtonPressed2,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 24),
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: Colors.transparent),
              ),
              child: Text(
                buttonText2,
                style: title_S.copyWith(color: AppColors.labelAlternative),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
