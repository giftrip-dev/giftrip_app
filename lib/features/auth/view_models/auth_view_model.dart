import 'package:flutter/material.dart';
import 'package:giftrip/features/root/screens/root_screen.dart';
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
    return const RootScreen(
      selectedIndex: 0,
    );
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
