import 'dart:io';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_template.dart';
import 'package:myong/core/utils/logger.dart';
import 'package:myong/features/auth/models/auth_result_model.dart';
import 'package:myong/features/auth/repositories/auth_repo.dart';
import 'package:myong/core/utils/amplitude_logger.dart';

class SocialLoginRepo {
  final Map<String, dynamic> resultMap = <String, dynamic>{};
  final authRepo = AuthRepository();

  // 네이버 로그인 요청
  Future<AuthRes> postNaverLogin() async {
    try {
      final NaverLoginResult naverResult = await FlutterNaverLogin.logIn();

      if (naverResult.status == NaverLoginStatus.loggedIn) {
        NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;
        final loginResult = await authRepo.postLoginWithSocial(res.accessToken,
            provider: 'naver');
        return AuthRes(isSuccess: true, user: loginResult.user);
      } else {
        logger.e('Login failed: ${naverResult.errorMessage}');
        return AuthRes(
          isSuccess: false,
          errorMessage: naverResult.errorMessage,
        );
      }
    } catch (e) {
      logger.e(e);
      return AuthRes(isSuccess: false, errorMessage: e.toString());
    } finally {
      AmplitudeLogger.logClickEvent(
          "naver_login", "naver_login", "login_screen");
    }
  }

  // 카카오 로그인 요청
  Future<AuthRes> postKakaoLogin() async {
    try {
      if (await isKakaoTalkInstalled()) {
        await UserApi.instance.loginWithKakaoTalk();
      } else {
        await UserApi.instance.loginWithKakaoAccount();
      }

      final OAuthToken? tokens =
          await TokenManagerProvider.instance.manager.getToken();

      if (tokens == null) {
        return AuthRes(
          isSuccess: false,
          errorMessage: '토큰이 없음',
        );
      }

      final accessToken = tokens.accessToken.toString();
      final loginResult =
          await authRepo.postLoginWithSocial(accessToken, provider: 'kakao');

      logger.d(loginResult.accessToken);
      return AuthRes(isSuccess: true, user: loginResult.user);
    } catch (error) {
      logger.e(error);
      return AuthRes(isSuccess: false, errorMessage: error.toString());
    } finally {
      AmplitudeLogger.logClickEvent(
          "kakao_login", "kakao_login", "login_screen");
    }
  }

  // 애플 로그인 요청
  Future<AuthRes> postAppleLogin() async {
    // 기기가 iOS가 아닌 경우 예외 처리
    if (!Platform.isIOS) {
      return AuthRes(isSuccess: false, errorMessage: "ANDROID");
    }

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final loginResult = await authRepo.postLoginWithSocial(
        credential.identityToken.toString(),
        provider: "apple",
      );

      return AuthRes(isSuccess: true, user: loginResult.user);
    } catch (e) {
      logger.e(e);
      return AuthRes(isSuccess: false, errorMessage: e.toString());
    } finally {
      AmplitudeLogger.logClickEvent(
          "apple_login", "apple_login", "login_screen");
    }
  }
}
