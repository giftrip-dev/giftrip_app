import 'package:flutter/material.dart';
import 'package:myong/core/widgets/tooltip/tooltip.dart';
import 'package:myong/features/auth/widgets/apple_login_button.dart';

// 소셜 로그인 버튼 + 안내 말풍선
Widget socialLoginBox({
  required BuildContext context,
}) {
  return Column(
    children: [
      CustomTooltip(text: '🩵 로그인하여 더 많은 혜택을 받아보세요 🩵'),
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
        children: [
          appleLoginButton(context: context),
        ],
      ),
    ],
  );
}
