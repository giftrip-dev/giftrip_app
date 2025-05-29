import 'package:flutter/material.dart';
import 'package:giftrip/features/root/screens/root_screen.dart';
import 'package:giftrip/features/auth/models/login_model.dart';
import 'package:giftrip/features/auth/models/register_model.dart';
import 'package:giftrip/features/auth/repositories/auth_repo.dart';
import 'package:giftrip/core/services/storage_service.dart';
import 'dart:developer' as developer;

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();
  final GlobalStorage _storage = GlobalStorage();
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

    final response = await _authRepo.postLogin(request);

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

  Future<bool> signUp(RegisterRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _authRepo.postSignUp(request);
    _isLoading = false;

    if (response.tokens != null) {
      await _storage.setToken(
        response.tokens!.accessToken,
        response.tokens!.refreshToken,
      );
      return true;
    } else {
      _errorMessage = "회원가입에 실패했습니다.";
      return false;
    }
  }

  Future<bool> completeSignUp({
    bool? isMarketingAgreed,
    bool? isTermsAgreed,
    bool? isPrivacyAgreed,
    required bool isInfluencer,
    required String platform,
    required String platformId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final request = CompleteSignUpRequest(
      isMarketingAgreed: isMarketingAgreed,
      isTermsAgreed: isTermsAgreed,
      isPrivacyAgreed: isPrivacyAgreed,
      isInfluencer: isInfluencer,
      influencerInfo: InfluencerInfo(
        platform: platform,
        platformId: platformId,
      ),
    );

    try {
      final response = await _authRepo.completeSignUp(request);
      _isLoading = false;
      notifyListeners();
      return response.isInfluencerChecked;
    } catch (e) {
      _isLoading = false;
      _errorMessage = '회원가입 완료에 실패했습니다.';
      notifyListeners();
      return false;
    }
  }
}
