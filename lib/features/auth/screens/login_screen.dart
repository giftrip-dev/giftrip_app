import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/features/auth/widgets/social_login_box.dart';
import 'package:myong/features/auth/widgets/terms_box.dart';
import 'package:myong/core/utils/amplitude_logger.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AmplitudeLogger.logViewEvent("app_login_screen_view", "app_login_screen");
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.primary,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 192),
                  _buildLogo(),
                  const SizedBox(height: 60),
                  _buildIllustrator()
                ],
              ),
            ),
            _buildBottomSection(context),
          ],
        ),
      ),
    );
  }

  // 로고
  Widget _buildLogo() {
    return Center(
      child: Image.asset(
        'assets/images/logo/logo.png',
        width: 205,
        height: 86,
      ),
    );
  }

  // 일러스트
  Widget _buildIllustrator() {
    return Center(
      child: Image.asset(
        'assets/images/illustrator/login.png',
        width: 206,
        height: 172,
      ),
    );
  }

  // 하단 섹션
  Widget _buildBottomSection(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 80,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            socialLoginBox(context: context),
            const SizedBox(height: 36),
            termsBox(context: context),
          ],
        ),
      ),
    );
  }
}
