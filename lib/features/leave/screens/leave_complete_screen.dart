import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/features/auth/screens/login_screen.dart';

class LeaveCompleteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAlternative,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '이용해주셔서 감사합니다\n언제든지 또 방문해주세요!',
                  style: h1_M,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  '탈퇴 후 7일 이내 로그인 시 계정 정보가 복구돼요!',
                  style: body_S.copyWith(color: AppColors.labelNatural),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                Image.asset(
                  'assets/images/illustrator/original.png',
                  width: 225,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 60,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('로그인 화면으로 돌아가기'),
            ),
          ),
        ],
      ),
    );
  }
}
