import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/core/services/storage_service.dart';
import 'package:giftrip/features/auth/models/login_model.dart';
import 'dart:developer' as developer;

class LoginRepository {
  final Dio _dio = DioClient().to();

  // 임시 로그인 계정
  static const String _tempId = 'test';
  static const String _tempPassword = '1234';

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      developer.log(
        '''로그인 요청:
        - 아이디: ${request.id}
        - 비밀번호: ${'*' * request.password.length}''',
        name: 'LoginRepository',
      );

      // 임시 로그인 계정 확인
      if (request.id == _tempId && request.password == _tempPassword) {
        developer.log(
          '임시 계정 로그인 성공',
          name: 'LoginRepository',
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
        name: 'LoginRepository',
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
        name: 'LoginRepository',
        error: e,
        stackTrace: stackTrace,
      );
      return LoginResponse(
        isSuccess: false,
        errorMessage: '로그인 중 오류가 발생했습니다.',
      );
    }
  }
}
