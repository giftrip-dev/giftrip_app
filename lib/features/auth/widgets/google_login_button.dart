import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/image/custom_image.dart';
import 'package:giftrip/core/widgets/modal/one_button_modal.dart';
import 'package:giftrip/core/widgets/modal/request_fail_modal.dart';
import 'package:giftrip/features/auth/repositories/social_login_repo.dart';
import 'package:giftrip/features/root/screens/root_screen.dart';
import 'package:giftrip/features/auth/screens/terms_agreement_screen.dart';
import 'package:giftrip/features/user/screens/nickname_form_screen.dart';
import 'package:giftrip/features/user/screens/select_category_screen.dart';

GestureDetector googleLoginButton({
  required BuildContext context,
  bool isLoading = false,
}) {
  final socialLoginRepo = SocialLoginRepo();

  return GestureDetector(
    onTap: () async {
      final result = await socialLoginRepo.postAppleLogin();

      if (!result.isSuccess && context.mounted) {
        if (result.errorMessage == "ANDROID") {
          showDialog(
            context: context,
            builder: (context) => OneButtonModal(
              title: '애플 로그인 안내',
              desc: "안드로이드 기기의 앱에서는 애플 계정으로 로그인할 수 없습니다.",
              onConfirm: () => Navigator.of(context).pop(),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => RequestFailModal(
              onConfirm: () => Navigator.of(context).pop(),
            ),
          );
        }
      } else {
        if (!context.mounted) return;
        if (result.user?.isTermsOfServiceConsent == false) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const TermsAgreementScreen(),
            ),
            (route) => false,
          );
        } else {
          if (result.user?.certificateStatus == "NOT_REQUESTED") {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const SelectCategoryScreen(),
              ),
              (route) => false,
            );
          } else {
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
                    selectedIndex: 0,
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
        color: Colors.white, // 흰색 배경
        shape: BoxShape.circle, // 원형 버튼
      ),
      alignment: Alignment.center,
      child: isLoading
          ? const CircularProgressIndicator(
              color: Colors.black,
            )
          : CustomImage(
              imageUrl: 'assets/svg/icons/google.svg', width: 48, height: 48),
    ),
  );
}
