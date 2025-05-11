import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/widgets/image/custom_image.dart';
import 'package:myong/features/auth/widgets/social_login_box.dart';
import 'package:myong/features/auth/widgets/terms_box.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.primary,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildLogo(),
                  const SizedBox(height: 60),
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
    return CustomImage(
      imageUrl: 'assets/png/logo.png',
      width: 183,
      height: 50,
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
