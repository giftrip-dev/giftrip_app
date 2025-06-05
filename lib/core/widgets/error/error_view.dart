import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final String buttonText;
  final VoidCallback onRetry;

  const ErrorView({
    this.message = '상품을 불러오는 중 오류가 발생했습니다.',
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
            Icon(
              Icons.error_outline_rounded,
              color: Theme.of(context).colorScheme.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: body_M.copyWith(color: AppColors.labelAlternative),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 120,
              child: CTAButton(
                type: CTAButtonType.outline,
                onPressed: onRetry,
                text: buttonText,
                isEnabled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
