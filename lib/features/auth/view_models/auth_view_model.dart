import 'package:flutter/material.dart';
import 'package:giftrip/core/services/storage_service.dart';
import 'package:giftrip/features/auth/screens/login_screen.dart';
import 'package:giftrip/features/root/screens/root_screen.dart';
import 'package:giftrip/features/auth/screens/terms_agreement_screen.dart';
import 'package:giftrip/features/user/screens/select_category_screen.dart';
import 'package:giftrip/features/user/screens/nickname_form_screen.dart';
import 'package:giftrip/features/user/view_models/user_view_model.dart';

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
        return const RootScreen(
          selectedIndex: 0,
        );
      } catch (e) {
        return const RootScreen(
          selectedIndex: 0,
        );
      }
    } else {
      return const RootScreen(
        selectedIndex: 0,
      );
    }
  }
}
