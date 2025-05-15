import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/app_bar/global_app_bar.dart';
import 'package:giftrip/core/widgets/bottom_sheet/one_button_bottom_sheet.dart';
import 'package:giftrip/features/user/screens/nickname_form_screen.dart';
import 'package:giftrip/features/root/screens/root_screen.dart';

class CertificationCompleteScreen extends StatelessWidget {
  final String? previousPage;
  const CertificationCompleteScreen({
    super.key,
    this.previousPage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAlternative,
      appBar: GlobalAppBar(
        noAlarm: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '재직 정보가\n 안전하게 전달되었어요!',
              style: h1_M.copyWith(color: AppColors.labelStrong),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              '오늘묭해가 꼼꼼히 확인 후\n자격증 검토가 끝나면 알림으로 알려드릴게요!',
              style: body_S.copyWith(color: AppColors.labelNatural),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Image.asset(
              'assets/images/illustrator/alarm.png',
              width: 150,
              height: 155,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
      bottomNavigationBar: OneButtonBottomSheet(
        backgroundColor: AppColors.backgroundAlternative,
        isEnabled: true,
        buttonText: previousPage == 'my_page' ? '확인' : '다음',
        onButtonPressed: () {
          if (previousPage == 'my_page') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const RootScreen(
                  selectedIndex: 4, // 마이 페이지로 이동
                ),
              ),
              (route) => false,
            );
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => NicknameFormScreen()),
              (route) => false,
            );
          }
        },
      ),
    );
  }
}
