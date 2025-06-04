import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/image/custom_image.dart';
import 'package:giftrip/core/widgets/modal/request_fail_modal.dart';
import 'package:giftrip/features/auth/repositories/social_login_repo.dart';
import 'package:giftrip/features/auth/screens/terms_agreement_screen.dart';
import 'package:giftrip/features/root/screens/root_screen.dart';

GestureDetector googleLoginButton({
  required BuildContext context,
  bool isLoading = false,
}) {
  final socialLoginRepo = SocialLoginRepo();

  return GestureDetector(
    onTap: () async {
      final result = await socialLoginRepo.postGoogleLogin();

      if (!result.isSuccess && context.mounted) {
        showDialog(
          context: context,
          builder: (context) => RequestFailModal(
            onConfirm: () => Navigator.of(context).pop(),
          ),
        );
      } else {
        if (!context.mounted || !result.isSuccess) return;

        // 인플루언서 인증 여부에 따라 라우팅
        if (result.user?.isInfluencerChecked == false) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => TermsAgreementScreen(
                fromSocialLogin: true,
              ),
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
