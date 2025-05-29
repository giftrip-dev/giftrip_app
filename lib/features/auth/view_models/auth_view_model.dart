import 'package:flutter/material.dart';
import 'package:giftrip/core/services/storage_service.dart';
import 'package:giftrip/core/storage/auth_storage.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/features/auth/screens/login_screen.dart';
import 'package:giftrip/features/auth/screens/influencer_check_screen.dart';
import 'package:giftrip/features/root/screens/root_screen.dart';
import 'package:giftrip/features/auth/models/login_model.dart';
import 'package:giftrip/features/auth/repositories/login_repo.dart';
import 'dart:developer' as developer;

import 'package:giftrip/features/user/view_models/user_view_model.dart';

class AuthViewModel extends ChangeNotifier {
  final LoginRepository _loginRepo = LoginRepository();
  final AuthStorage _authStorage = AuthStorage();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<Widget> checkAutoLogin() async {
    final autoLoginStatus = await _authStorage.getAutoLogin();

    if (autoLoginStatus) {
      final user = await _authStorage.getUserInfo();

      // 유저 정보가 없으면 로그인 화면으로 이동
      if (user == null) {
        return const LoginScreen();
      }

      logger.i('user.isInfluencerChecked: ${user.isInfluencerChecked}');
      // 인플루언서 인증 여부 확인
      if (user.isInfluencerChecked) {
        return const RootScreen(
          selectedIndex: 0,
        );
      } else {
        return const InfluencerCheckScreen();
      }
    } else {
      return const LoginScreen();
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
