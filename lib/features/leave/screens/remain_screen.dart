import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/features/root/screens/root_screen.dart';

class RemainScreen extends StatelessWidget {
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
                  '앞으로도 오늘묭해를 기대해주세요!',
                  style: h1_M,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  '오늘묭해를 한 번 더 믿어주셔서 감사합니다.\n피드백을 보완하여 보다 재밌고 풍성한\n오늘묭해를 선보일 수 있도록 최선을 다하겠습니다.',
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
                  MaterialPageRoute(
                      builder: (context) => RootScreen(
                            selectedIndex: 0,
                          )),
                );
              },
              child: Text('홈으로 돌아가기'),
            ),
          ),
        ],
      ),
    );
  }
}
