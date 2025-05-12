import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/widgets/app_bar/back_button_app_bar.dart';
import 'package:myong/core/widgets/image/custom_image.dart';
import 'package:myong/core/widgets/tooltip/tooltip.dart';
import 'package:myong/features/auth/widgets/social_login_box.dart';
import 'package:myong/features/auth/widgets/terms_box.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackButtonAppBar(
        type: BackButtonAppBarType.textCenter,
        title: '로그인',
        onBack: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.white,
          child: Column(
            children: [
              const SizedBox(height: 98.25),
              // 로고
              _buildLogo(),
              const SizedBox(height: 98.25),
              // 안내문구

              CustomTooltip(text: '🩵 로그인하여 더 많은 혜택을 받아보세요 🩵'),

              const SizedBox(height: 8),
              // 아이디/비밀번호 입력
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: '아이디를 입력해주세요',
                        hintStyle:
                            body_M.copyWith(color: AppColors.labelAlternative),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.line,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '비밀번호를 입력해주세요',
                        hintStyle:
                            body_M.copyWith(color: AppColors.labelAlternative),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.line,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        suffixIcon: Icon(
                          LucideIcons.eyeOff,
                          color: AppColors.labelAlternative,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.labelStrong,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 13.5),
                        ),
                        onPressed: () {},
                        child: const Text('로그인', style: title_S),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text('회원가입',
                              style: TextStyle(color: Colors.grey)),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('아이디 / 비밀번호 찾기',
                              style: TextStyle(color: Colors.grey)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // const Spacer(),
              // SNS 소셜 로그인, 약관
              socialLoginBox(context: context),
              const SizedBox(height: 36),
              termsBox(context: context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // 로고
  Widget _buildLogo() {
    return CustomImage(
      imageUrl: 'assets/png/logo.png',
      width: 185,
      height: 50,
    );
  }
}
