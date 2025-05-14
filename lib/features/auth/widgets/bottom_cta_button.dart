import 'package:flutter/material.dart';
import 'package:myong/core/widgets/button/cta_button.dart';

class BottomCTAButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback? onPressed;
  final String text;

  const BottomCTAButton({
    super.key,
    required this.isEnabled,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      child: SafeArea(
        child: CTAButton(
          isEnabled: isEnabled,
          onPressed: onPressed,
          text: text,
        ),
      ),
    );
  }
}
