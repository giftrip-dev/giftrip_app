import 'package:flutter/material.dart';
import 'package:giftrip/features/auth/widgets/apple_login_button.dart';
import 'package:giftrip/features/auth/widgets/google_login_button.dart';

// 소셜 로그인 버튼 + 안내 말풍선
Widget socialLoginBox({
  required BuildContext context,
}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
        children: [
          googleLoginButton(context: context),
          const SizedBox(width: 24),
          appleLoginButton(context: context),
        ],
      ),
    ],
  );
}
