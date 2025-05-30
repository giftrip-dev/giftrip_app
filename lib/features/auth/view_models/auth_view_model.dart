import 'package:flutter/material.dart';
import 'package:giftrip/core/storage/auth_storage.dart';
import 'package:giftrip/features/auth/screens/login_screen.dart';
import 'package:giftrip/features/auth/screens/influencer_check_screen.dart';
import 'package:giftrip/features/root/screens/root_screen.dart';
import 'package:giftrip/features/auth/models/register_model.dart';
import 'package:giftrip/features/auth/repositories/auth_repo.dart';
import 'package:giftrip/features/user/models/dto/user_dto.dart';
import 'package:giftrip/features/user/view_models/user_view_model.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthStorage _authStorage = AuthStorage();
  final AuthRepository _authRepo = AuthRepository();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 자동 로그인 확인
  Future<Widget> checkAutoLogin() async {
    final autoLoginStatus = await _authStorage.getAutoLogin();

    if (autoLoginStatus) {
      final user = await _authStorage.getUserInfo();

      // 유저 정보가 없으면 로그인 화면으로 이동
      if (user == null) {
        return const LoginScreen();
      }

      // 인플루언서 인증 여부 확인
      if (user.isInfluencerChecked) {
        return const RootScreen(
          selectedIndex: 0,
        );
      } else {
        // 자동 로그인에서는 소셜 로그인으로 간주
        return const InfluencerCheckScreen(fromSocialLogin: true);
      }
    } else {
      return const RootScreen(
        selectedIndex: 0,
      );
    }
  }

  // 로그인
  Future<Widget?> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _authRepo.postLogin(email, password);

    _isLoading = false;
    notifyListeners();

    if (response.isSuccess) {
      // 1) 메모리 상의 전역 유저 상태 업데이트
      UserViewModel().updateUser(UserUpdateRequestDto(
        name: response.name,
        isInfluencerChecked: response.isInfluencerChecked,
      ));

      // 2) 인플루언서 여부에 따라 다음 화면 반환
      if (!response.isInfluencerChecked) {
        return const InfluencerCheckScreen(fromSocialLogin: false);
      } else {
        return const RootScreen(selectedIndex: 0);
      }
    }

    // 실패 시 에러 메시지 저장
    _errorMessage = response.errorMessage ?? '로그인에 실패했습니다.';
    notifyListeners();
    return null;
  }

  Future<bool> signUp(RegisterRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authRepo.postSignUp(request);

      // 유저 정보 업데이트 (이름, 인플루언서 여부)
      UserViewModel().updateUser(UserUpdateRequestDto(
        name: response.name,
        isInfluencerChecked: response.isInfluencerChecked,
      ));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> completeSignUp({
    bool? isMarketingAgreed,
    bool? isTermsAgreed,
    bool? isPrivacyAgreed,
    required bool isInfluencer,
    String? platform,
    String? platformId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final request = CompleteSignUpRequest(
      isMarketingAgreed: isMarketingAgreed,
      isTermsAgreed: isTermsAgreed,
      isPrivacyAgreed: isPrivacyAgreed,
      isInfluencer: isInfluencer,
      influencerInfo: (isInfluencer && platform != null && platformId != null)
          ? InfluencerInfo(
              platform: platform,
              platformId: platformId,
            )
          : null,
    );

    try {
      final response = await _authRepo.completeSignUp(request);
      _isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      _isLoading = false;
      _errorMessage = '회원가입 완료에 실패했습니다.';
      notifyListeners();
      return false;
    }
  }
}
