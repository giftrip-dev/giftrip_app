import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final String buttonText;
  final VoidCallback onRetry;

  const ErrorView({
    this.message = '데이터를 불러오는 중 오류가 발생했습니다.',
    this.buttonText = '다시 시도',
    required this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message),
            const SizedBox(height: 16),
            CTAButton(
              onPressed: onRetry,
              text: buttonText,
              isEnabled: true,
            ),
          ],
        ),
      ),
    );
  }
}
