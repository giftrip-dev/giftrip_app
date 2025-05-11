import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/widgets/bottom_sheet/one_button_bottom_sheet.dart';
import 'package:myong/features/root/screens/root_screen.dart';

class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAlternative,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '미용인을 위한\n 새로운 커뮤니티의 시작!',
              style: h1_M.copyWith(color: AppColors.labelStrong),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              '4대 미용(헤어,메이크업,네일,피부)을\n업으로 삼고 있는 전국의 미용인이 모여있어요!',
              style: body_3.copyWith(color: AppColors.labelNatural),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 102),
            Image.asset(
              'assets/images/illustrator/original.png',
              width: 225,
              height: 190,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
      bottomNavigationBar: OneButtonBottomSheet(
        backgroundColor: AppColors.backgroundAlternative,
        isEnabled: true,
        buttonText: '시작하기',
        onButtonPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const RootScreen()),
            (route) => false,
          );
        },
      ),
    );
  }
}
