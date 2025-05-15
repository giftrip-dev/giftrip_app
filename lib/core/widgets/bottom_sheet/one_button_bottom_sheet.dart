import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';

class OneButtonBottomSheet extends StatelessWidget {
  final bool isEnabled;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final Color backgroundColor;
  const OneButtonBottomSheet({
    Key? key,
    required this.isEnabled,
    required this.buttonText,
    required this.onButtonPressed,
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
        ],
      ),
    );
  }
}
