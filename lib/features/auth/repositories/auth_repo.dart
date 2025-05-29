import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/core/services/storage_service.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/features/auth/models/auth_result_model.dart';
import 'package:giftrip/features/auth/models/user_model.dart';
import 'package:giftrip/features/auth/models/register_model.dart';
import 'package:giftrip/features/auth/models/login_model.dart';
import 'package:giftrip/features/notification/view_models/notification_view_model.dart';
import 'package:giftrip/features/notification/models/notification_model.dart';
import 'dart:developer' as developer;

class AuthRepository {
  final Dio _dio = DioClient().to();
  final Map<String, dynamic> resultMap = <String, dynamic>{};
  final GlobalStorage _storage = GlobalStorage();

  // 임시 로그인 계정
  static const String _tempId = 'test';
  static const String _tempPassword = '1234';

  // 로그인 요청
  Future<LoginResponse> postLogin(LoginRequest request) async {
    try {
      developer.log(
        '''로그인 요청:
        - 아이디: ${request.id}
        - 비밀번호: ${'*' * request.password.length}''',
        name: 'AuthRepository',
      );

      // 임시 로그인 계정 확인
      if (request.id == _tempId && request.password == _tempPassword) {
        developer.log(
          '임시 계정 로그인 성공',
          name: 'AuthRepository',
        );
        return LoginResponse(
          isSuccess: true,
          accessToken: 'temp_access_token',
          refreshToken: 'temp_refresh_token',
          userId: 'temp_user_id',
        );
      }

      developer.log(
        '로그인 실패: 잘못된 아이디 또는 비밀번호',
        name: 'AuthRepository',
      );
      return LoginResponse(
        isSuccess: false,
        errorMessage: '아이디 또는 비밀번호가 일치하지 않습니다.',
      );

      // TODO: 실제 API 구현 시 아래 주석 해제
      // final response = await _dio.post(
      //   '/api/auth/login',
      //   data: request.toJson(),
      // );
      //
      // if (response.statusCode == 200) {
      //   final data = response.data;
      //   // 토큰 저장
      //   if (data['accessToken'] != null) {
      //     await GlobalStorage().setAccessToken(data['accessToken']);
      //   }
      //   if (data['refreshToken'] != null) {
      //     await GlobalStorage().setRefreshToken(data['refreshToken']);
      //   }
      //   return LoginResponse.fromJson(data);
      // } else {
      //   return LoginResponse(
      //     isSuccess: false,
      //     errorMessage: '로그인에 실패했습니다.',
      //   );
      // }
    } catch (e, stackTrace) {
      developer.log(
        '로그인 중 오류 발생',
        name: 'AuthRepository',
        error: e,
        stackTrace: stackTrace,
      );
      return LoginResponse(
        isSuccess: false,
        errorMessage: '로그인 중 오류가 발생했습니다.',
      );
    }
  }

  // 회원가입 요청
  Future<RegisterResponse> postSignUp(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '/api/v1/auth/sign-up',
        data: request.toJson(),
      );

      if (response.statusCode == 201) {
        final data = response.data;
        await GlobalStorage().setToken(
          data['accessToken'],
          data['refreshToken'],
        );
        return RegisterResponse.fromJson(data);
      } else {
        return RegisterResponse(
          tokens: null,
        );
      }
    } catch (e) {
      return RegisterResponse(
        tokens: null,
      );
    }
  }

  // 이메일 중복 체크
  Future<bool> checkEmailDuplicate(String email) async {
    try {
      final response = await _dio.get(
        '/api/auth/check-email',
        queryParameters: {'email': email},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // 리프레쉬 토큰으로 액세스 토큰 재발급
  Future<void> refreshAccessToken() async {
    try {
      String? refreshToken = await GlobalStorage().getRefreshToken();
      if (refreshToken == null) {
        throw Exception("리프레시 토큰이 없음");
      }

      final response = await _dio.post(
        '/api/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 201) {
        final tokenInfo = response.data;
        await GlobalStorage()
            .setToken(tokenInfo['accessToken'], tokenInfo['refreshToken']);
        logger.d('새로운 액세스 토큰 저장 완료: ${tokenInfo['accessToken']}');
      } else {
        throw Exception("토큰 갱신 실패: ${response.statusCode}");
      }
    } catch (e) {
      logger.e("토큰 갱신 중 오류 발생: $e");
      rethrow;
    }
  }

  // 소셜 로그인 요청
  Future<LoginRes> postLoginWithSocial(
    String accessToken, {
    String? provider,
  }) async {
    final response = await _dio.post(
      '/api/auth/social-login',
      data: {
        'provider': provider,
        'accessToken': accessToken,
      },
    );

    if (response.statusCode == 201) {
      final statusCode = response.statusCode.toString();

      final refreshToken = response.data['tokens']['refreshToken'];
      final accessToken = response.data['tokens']['accessToken'];
      final isFirstLogin = response.data['isFirstLogin'] ?? false;
      final certificateStatus =
          response.data['certificateStatus'] ?? 'NOT_REQUESTED';

      final user = UserModel.fromJson(
        response.data['user'],
        isFirstLogin: isFirstLogin,
        certificateStatus: certificateStatus,
      );
      final fcmToken = await GlobalStorage().getFcmToken();
      final deviceId = await GlobalStorage().getDeviceId();
      final deviceModel = await GlobalStorage().getDeviceModel();
      final notificationViewModel = NotificationViewModel();
      // 토큰, 유저 정보 글로벌 스토리지 저장
      await GlobalStorage().setToken(accessToken, refreshToken);
      await GlobalStorage().setUserInfo(user);
      await GlobalStorage().setAutoLogin(); // 자동 로그인 활성화
      await notificationViewModel.registerFCMToken(
          fcmData: FCMTokenModel(
        token: fcmToken ?? '',
        deviceId: deviceId ?? '',
        deviceModel: deviceModel ?? '',
      ));
      return LoginRes(
        statusCode: statusCode,
        refreshToken: refreshToken,
        accessToken: accessToken,
        user: user,
      );
    } else {
      throw Exception("로그인 실패: ${response.statusCode}");
    }
  }

  /// 로그아웃 요청
  Future<bool> logout() async {
    try {
      final response = await _dio.post('/api/auth/logout');

      if (response.statusCode == 201) {
        await _storage.deleteUserInfo();
        await _storage.deleteLoginToken();
        await _storage.removeAutoLogin();
        return true;
      } else {
        throw Exception('로그아웃 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('로그아웃 API 요청 실패: $e');
    }
  }

  Future<CompleteSignUpResponse> completeSignUp(
      CompleteSignUpRequest request) async {
    try {
      final response = await _dio.patch(
        '/api/v1/auth/complete-sign-up',
        data: request.toJson(),
      );
      if (response.statusCode == 200) {
        return CompleteSignUpResponse.fromJson(response.data);
      } else {
        throw Exception('회원가입 완료 실패: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
