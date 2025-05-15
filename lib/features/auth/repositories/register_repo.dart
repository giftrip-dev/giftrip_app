import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/core/services/storage_service.dart';
import 'package:giftrip/features/auth/models/register_model.dart';

class RegisterRepository {
  final Dio _dio = DioClient().to();

  // 회원가입 요청
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      // TODO: 실제 API 구현 시 아래 주석 해제
      // final response = await _dio.post(
      //   '/api/auth/register',
      //   data: request.toJson(),
      // );
      //
      // if (response.statusCode == 201) {
      //   final data = response.data;
      //   await GlobalStorage().setToken(
      //     data['accessToken'],
      //     data['refreshToken'],
      //   );
      //   return RegisterResponse.fromJson(data);
      // } else {
      //   return RegisterResponse(
      //     isSuccess: false,
      //     errorMessage: '회원가입에 실패했습니다.',
      //   );
      // }

      // 임시: 성공으로 처리
      return RegisterResponse(
        isSuccess: true,
        userId: 'temp_user_id',
        accessToken: 'temp_access_token',
        refreshToken: 'temp_refresh_token',
      );
    } catch (e) {
      return RegisterResponse(
        isSuccess: false,
        errorMessage: '회원가입 중 오류가 발생했습니다.',
      );
    }
  }

  // 이메일 중복 체크
  Future<bool> checkEmailDuplicate(String email) async {
    try {
      // TODO: 실제 API 구현 시 아래 주석 해제
      // final response = await _dio.get(
      //   '/api/auth/check-email',
      //   queryParameters: {'email': email},
      // );
      // return response.statusCode == 200;

      // 임시: 항상 사용 가능한 이메일로 처리
      return true;
    } catch (e) {
      return false;
    }
  }
}
