import 'dart:io';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_template.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/features/auth/models/auth_result_model.dart';
import 'package:giftrip/features/auth/repositories/auth_repo.dart';
import 'package:giftrip/core/utils/amplitude_logger.dart';

class SocialLoginRepo {
  final Map<String, dynamic> resultMap = <String, dynamic>{};
  final authRepo = AuthRepository();

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
