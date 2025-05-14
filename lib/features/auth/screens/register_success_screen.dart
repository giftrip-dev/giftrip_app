import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/features/auth/widgets/bottom_cta_button.dart';

class RegisterSuccessScreen extends StatelessWidget {
  const RegisterSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            Text("회원가입", style: title_M.copyWith(color: AppColors.labelStrong)),
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEBF6FF), // #EBF6FF 0%
              Color(0xFFFFFFFF), // #FFFFFF 45.9%
              Color(0xFFE9EDFF), // #E9EDFF 100%
            ],
            stops: [0.0, 0.459, 1.0],
          ),
        ),
        width: double.infinity,
        height: double.infinity,
      ),
      bottomNavigationBar: BottomCTAButton(
        onPressed: () {},
        text: "홈으로 이동",
        isEnabled: true,
      ),
    );
  }
}
