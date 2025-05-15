import 'package:flutter/material.dart';
import 'package:giftrip/core/services/storage_service.dart';
import 'package:giftrip/features/auth/screens/login_screen.dart';
import 'package:giftrip/features/root/screens/root_screen.dart';
import 'package:giftrip/features/auth/screens/terms_agreement_screen.dart';
import 'package:giftrip/features/user/screens/select_category_screen.dart';
import 'package:giftrip/features/user/screens/nickname_form_screen.dart';
import 'package:giftrip/features/user/view_models/user_view_model.dart';
import 'package:giftrip/features/auth/models/login_model.dart';
import 'package:giftrip/features/auth/repositories/login_repo.dart';
import 'dart:developer' as developer;

class AuthViewModel extends ChangeNotifier {
  final LoginRepository _loginRepo = LoginRepository();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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

  Future<bool> login(String id, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    developer.log(
      '''로그인 시도:
      - 아이디: $id
      - 비밀번호: ${'*' * password.length}''',
      name: 'AuthViewModel',
    );

    final request = LoginRequest(
      id: id,
      password: password,
    );

    final response = await _loginRepo.login(request);

    _isLoading = false;

    if (response.isSuccess) {
      developer.log(
        '로그인 성공',
        name: 'AuthViewModel',
      );
      // TODO: 로그인 성공 후 처리 (예: 홈 화면으로 이동)
      return true;
    } else {
      _errorMessage = response.errorMessage;
      developer.log(
        '로그인 실패: ${response.errorMessage}',
        name: 'AuthViewModel',
      );
      notifyListeners();
      return false;
    }
  }
}
