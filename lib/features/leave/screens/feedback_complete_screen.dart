import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/widgets/modal/request_fail_modal.dart';
import 'package:myong/core/widgets/tooltip/tooltip.dart';
import 'package:myong/features/leave/repositories/leave_repo.dart';
import 'package:myong/features/leave/screens/leave_complete_screen.dart';
import 'package:myong/features/leave/screens/remain_screen.dart';
import 'package:myong/core/utils/amplitude_logger.dart';

class FeedbackCompleteScreen extends StatefulWidget {
  @override
  State<FeedbackCompleteScreen> createState() => _FeedbackCompleteScreenState();
}

class _FeedbackCompleteScreenState extends State<FeedbackCompleteScreen> {
  @override
  void initState() {
    super.initState();
    AmplitudeLogger.logViewEvent(
        "app_feedback_complete_screen_view", "app_feedback_complete_screen");
  }

  final LeaveRepo leaveRepo = LeaveRepo(); // 탈퇴 API 호출을 위한 인스턴스

  // 탈퇴하기 핸들러
  void handleDeleteUser(BuildContext context) async {
    AmplitudeLogger.logClickEvent("app_withdraw_complete_click",
        "app_withdraw_complete_button", "app_feedback_complete_screen");
    bool isDeleted = await leaveRepo.deleteUser();
    if (isDeleted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LeaveCompleteScreen()),
        (route) => false,
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return RequestFailModal(
            onConfirm: () => Navigator.of(context).pop(),
          );
        },
      );
    }
  }

  // 함께하기 핸들러
  void handleRemain(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => RemainScreen()),
      (route) => false,
    );
    AmplitudeLogger.logClickEvent("app_withdraw_cancel_click",
        "app_withdraw_cancel_button", "app_feedback_complete_screen");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAlternative,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 196),
                Text(
                  '소중한 피드백을\n빛보다 빠르게 전달했어요!',
                  style: h1_M,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  '회원님이 전달해주신 피드백을 바탕으로 보다 즐겁고 건전한 커뮤니티를 만들 수 있도록 노력하겠습니다.',
                  style: body_3.copyWith(color: AppColors.labelNatural),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 75),
                CustomTooltip(
                  isDark: true,
                  text: '오늘 묭해가 꾸준히 나아가는 여정들을\n계속 함께해주실 수 있나요?🥹',
                  size: "md",
                ),
                SizedBox(height: 12),
                Image.asset(
                  'assets/images/illustrator/crying.png',
                  width: 140,
                  height: 195,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 60,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () => handleDeleteUser(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      side: BorderSide(color: AppColors.lineStrong),
                    ),
                    child: Text('탈퇴하기'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => handleRemain(context),
                    child: Text('오늘묭해와 계속 함께하기'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
