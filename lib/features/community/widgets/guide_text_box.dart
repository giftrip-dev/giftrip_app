import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';

class GuideTextBox extends StatelessWidget {
  const GuideTextBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 커뮤니티 규칙
        Text(
          "오늘묭해는 인증된 뷰티 종사자 회원으로만 이루어진 미용 커뮤니티입니다. 누구나 기분 좋게 활동할 수 있도록 오늘묭해는 커뮤니티 이용규칙을 제정하여 운영하고 있으며 위반 시 게시물이 삭제되고 타 이용 회원에게 신고를 받을 시 서비스 이용이 차단됩니다.",
          style: caption.copyWith(color: AppColors.labelAlternative),
        ),
        const SizedBox(height: 11),

        // 안내말
        Text(
          "커뮤니티 금지사항 요약 사항이며, 자세한 이용규칙은 공지사항을 확인해주시기 바랍니다.",
          style: caption.copyWith(color: AppColors.labelAlternative),
        ),
        const SizedBox(height: 11),

        Text("🚫 정치,사회 관련 행위 금지",
            style: caption.copyWith(color: AppColors.labelAlternative)),
        const SizedBox(height: 11),
        Text("🚫 홍보 및 판매 관련 광고 행위 금지",
            style: caption.copyWith(color: AppColors.labelAlternative)),
        const SizedBox(height: 11),
        Text("🚫 불법촬영물 유통 금지",
            style: caption.copyWith(color: AppColors.labelAlternative)),
        const SizedBox(height: 11),
        Text("🚫 범죄,불법 행위 등 법령을 위반하는 글 금지",
            style: caption.copyWith(color: AppColors.labelAlternative)),
        const SizedBox(height: 11),
        Text("🚫 음란물, 성적 수치심을 유발하는 글 금지",
            style: caption.copyWith(color: AppColors.labelAlternative)),
      ],
    );
  }
}
