import 'package:flutter/material.dart';
import 'package:myong/core/services/storage_service.dart';
import 'package:myong/features/auth/screens/login_screen.dart';
// import 'package:myong/features/root/screens/root_screen.dart';
import 'package:myong/features/auth/screens/terms_agreement_screen.dart';
import 'package:myong/features/user/screens/select_category_screen.dart';
import 'package:myong/features/user/screens/nickname_form_screen.dart';
import 'package:myong/features/user/view_models/user_view_model.dart';
import 'package:myong/features/home/screens/home_screen.dart';

class AuthViewModel extends ChangeNotifier {
  Future<Widget> checkAutoLogin() async {
    final autoLoginStatus = await GlobalStorage().getAutoLogin();

    if (autoLoginStatus) {
      try {
        final user = await UserViewModel().getUserInfo();

        if (user == null) {
          return const LoginScreen();
        }

        // 약관 동의를 하지 않은 경우
        if (user.isTermsOfServiceConsent != true) {
          return const TermsAgreementScreen();
        }
        // 자격 인증을 하지 않은 경우
        else if (user.certificateStatus == "NOT_REQUESTED") {
          return const SelectCategoryScreen();
        }
        // 닉네임을 설정하지 않은 경우
        else if (user.nickname == null) {
          return NicknameFormScreen();
        }
        // 항상 HomeScreen으로 이동하도록 임시 수정
        return const HomeScreen();
      } catch (e) {
        return const HomeScreen();
      }
    } else {
      return const HomeScreen();
    }
  }
}
