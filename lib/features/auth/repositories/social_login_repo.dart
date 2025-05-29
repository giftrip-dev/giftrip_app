import 'dart:io';
import 'package:giftrip/features/auth/models/user_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/features/auth/models/auth_result_model.dart';
import 'package:giftrip/features/auth/repositories/auth_repo.dart';
import 'package:giftrip/core/utils/amplitude_logger.dart';

class SocialLoginRepo {
  final Map<String, dynamic> resultMap = <String, dynamic>{};
  final authRepo = AuthRepository();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 애플 로그인 요청
  Future<AuthRes> postAppleLogin() async {
    // 기기가 iOS가 아닌 경우 예외 처리
    if (!Platform.isIOS) {
      logger.d('iOS 기기가 아님');
      return AuthRes(isSuccess: false, errorMessage: "ANDROID");
    }

    try {
      logger.d('애플 로그인 인증 시도');
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      logger.d('애플 로그인 인증 성공: ${credential.identityToken}');

      logger.d('서버 로그인 시도');
      final loginResult = await authRepo.postLoginWithSocial(
        credential.identityToken.toString(),
        provider: "apple",
      );

      return AuthRes(
          isSuccess: true,
          user: UserModel(
              name: loginResult.name ?? '',
              isInfluencerChecked: loginResult.isInfluencerChecked));
    } catch (e) {
      logger.e('애플 로그인 실패: $e');
      return AuthRes(isSuccess: false, errorMessage: e.toString());
    } finally {
      AmplitudeLogger.logClickEvent(
          "apple_login", "apple_login", "login_screen");
    }
  }

  Future<AuthRes> postGoogleLogin() async {
    logger.d('구글 로그인 시작');
    try {
      logger.d('구글 로그인 시도');
      final GoogleSignInAccount? result = await _googleSignIn.signIn();

      if (result == null) {
        logger.d('구글 로그인 취소됨');
        return AuthRes(isSuccess: false, errorMessage: "로그인이 취소되었습니다.");
      }
      logger.d('구글 로그인 성공: ${result.email}');

      logger.d('구글 인증 토큰 요청');
      final GoogleSignInAuthentication googleAuth = await result.authentication;
      logger.d('구글 인증 토큰 획득: ${googleAuth.idToken}');

      logger.d('서버 로그인 시도');
      final loginResult = await authRepo.postLoginWithSocial(
        googleAuth.idToken.toString(),
        provider: "google",
      );
      logger.d('서버 로그인 성공: ${loginResult.name}');

      return AuthRes(
          isSuccess: true,
          user: UserModel(
              name: loginResult.name ?? '',
              isInfluencerChecked: loginResult.isInfluencerChecked));
    } catch (e) {
      logger.e('구글 로그인 실패: $e');
      return AuthRes(isSuccess: false, errorMessage: e.toString());
    } finally {
      AmplitudeLogger.logClickEvent(
          "google_login", "google_login", "login_screen");
    }
  }
}
