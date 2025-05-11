import 'package:flutter/material.dart';
import 'package:myong/core/widgets/modal/request_fail_modal.dart';
import 'package:myong/features/auth/repositories/social_login_repo.dart';
import 'package:myong/features/root/screens/root_screen.dart';
import 'package:myong/features/terms/screens/terms_agreement_screen.dart';
import 'package:myong/features/user/screens/select_category_screen.dart';
import 'package:myong/features/user/screens/nickname_form_screen.dart';

Widget socialLoginButton({
  required BuildContext context,
  required String type,
}) {
  final isKakao = type == 'kakao'; // 카카오 여부
  final socialLoginRepo = SocialLoginRepo();

  return GestureDetector(
    onTap: () async {
      final result = isKakao
          ? await socialLoginRepo.postKakaoLogin()
          : await socialLoginRepo.postNaverLogin();

      // 로그인 실패한 경우
      if (!result.isSuccess && context.mounted) {
        showDialog(
          context: context,
          builder: (context) => RequestFailModal(
            onConfirm: () => Navigator.of(context).pop(),
          ),
        );
      }
      // 로그인 성공한 경우
      else {
        if (!context.mounted) return;
        if (result.user?.isTermsOfServiceConsent == false) {
          // 약관 동의 안한 경우
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const TermsAgreementScreen(),
            ),
            (route) => false,
          );
        } else {
          if (result.user?.certificateStatus == "NOT_REQUESTED") {
            // 자격증명 안한 경우
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const SelectCategoryScreen(),
              ),
              (route) => false,
            );
          } else {
            // 닉네임 설정 안한 경우
            if (result.user?.nickname == null) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const NicknameFormScreen(),
                ),
                (route) => false,
              );
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const RootScreen(
                    selectedIndex: 0, // 홈 페이지로 이동
                  ),
                ),
                (route) => false,
              );
            }
          }
        }
      }
    },
    child: Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isKakao ? const Color(0xFFFFE500) : const Color(0xFF03C75A),
        shape: BoxShape.circle, // 원형 버튼
      ),
      alignment: Alignment.center,
      child: Image.asset(
        isKakao
            ? 'assets/images/icon/kakao.png'
            : 'assets/images/icon/naver.png',
        width: isKakao ? 40 : 28,
        height: isKakao ? 40 : 28,
      ),
    ),
  );
}
