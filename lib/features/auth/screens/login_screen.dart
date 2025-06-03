import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/app_bar/back_button_app_bar.dart';
import 'package:giftrip/core/widgets/image/custom_image.dart';
import 'package:giftrip/core/widgets/tooltip/tooltip.dart';
import 'package:giftrip/features/auth/widgets/social_login_box.dart';
import 'package:giftrip/features/auth/widgets/terms_box.dart';
import 'package:giftrip/features/auth/widgets/login_input_fields.dart';
import 'package:giftrip/features/root/screens/root_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackButtonAppBar(
          type: BackButtonAppBarType.textCenter,
          title: '로그인',
          onBack: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const RootScreen(
                    selectedIndex: 0,
                  ),
                ),
                (route) => false,
              )),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.white,
          child: SingleChildScrollView(
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
                  child: const LoginInputFields(),
                ),
                const SizedBox(height: 32),
                // SNS 소셜 로그인, 약관
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: AppColors.line,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 19),
                      Text(
                        'SNS 소셜 로그인하기',
                        style: caption.copyWith(color: AppColors.labelNatural),
                      ),
                      const SizedBox(width: 19),
                      Expanded(
                        child: Container(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: AppColors.line,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                socialLoginBox(context: context),
                const SizedBox(height: 36),
                termsBox(context: context),
                const SizedBox(height: 16),
              ],
            ),
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
