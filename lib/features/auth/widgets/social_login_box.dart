import 'package:flutter/material.dart';
import 'package:myong/core/widgets/tooltip/tooltip.dart';
import 'package:myong/features/auth/widgets/apple_login_button.dart';
import 'package:myong/features/auth/widgets/social_login_button.dart';

// 소셜 로그인 버튼 + 안내 말풍선
Widget socialLoginBox({
  required BuildContext context,
}) {
  return Column(
    children: [
      CustomTooltip(text: '🤍 간편하게 이용하는 1분 소셜로그인 🤍'),
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
        children: [
          socialLoginButton(
            context: context,
            type: 'naver',
          ),
          const SizedBox(width: 24), // 버튼 간격
          socialLoginButton(
            context: context,
            type: 'kakao',
          ),
          const SizedBox(width: 24), // 버튼 간격
          appleLoginButton(context: context),
        ],
      ),
    ],
  );
}
