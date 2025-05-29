import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/features/auth/models/verification_code_model.dart';

class VerificationRepository {
  final Dio _dio = DioClient().to();

  // 인증 코드 전송
  Future<VerificationResult> sendVerificationCode(String phoneNumber) async {
    // TODO: 실제 API 구현 시 아래 주석 해제
    try {
      final response = await _dio.post(
        '/auth/phone-verifications',
        data: {
          'phone': phoneNumber,
        },
      );
      return VerificationResult.fromJson(response.data);
    } catch (e) {
      return VerificationResult(
        isSended: false,
        dailyRemaining: null,
        error: Error(
          code: 'VERIFICATION_ERROR',
          message: e is DioException
              ? (e.response?.data?['message'] ?? '인증번호 전송에 실패했습니다.')
              : '인증번호 전송에 실패했습니다.',
          remainingAttempts: null,
          expiresIn: null,
        ),
        phone: phoneNumber,
      );
    }

    // 임시: 항상 성공으로 처리
    // return true;
  }

  // 인증 코드 검증
  Future<VerificationResult> verifyCode(VerificationCode code) async {
    try {
      final response = await _dio.put(
        '/auth/phone-verifications',
        data: code.toJson(),
      );
      return VerificationResult.fromJson(response.data);
    } catch (e) {
      return VerificationResult(
        success: false,
        isVerified: false,
        error: Error(
          code: 'VERIFICATION_ERROR',
          message: e is DioException
              ? (e.response?.data?['message'] ?? '인증번호 확인에 실패했습니다.')
              : '인증번호 확인에 실패했습니다.',
          remainingAttempts: null,
          expiresIn: null,
        ),
        phone: code.phone,
      );
    }

    // 임시: 123456 코드로 통과
    // if (code.code == '123456') {
    //   return VerificationResult(
    //     success: true,
    //     isVerified: true,
    //     error: Error(
    //       code: null,
    //       message: null,
    //       remainingAttempts: null,
    //       expiresIn: null,
    //     ),
    //     phone: code.phone,
    //   );
    // } else {
    //   return VerificationResult(
    //     success: false,
    //     isVerified: false,
    //     error: Error(
    //       code: 'CODE_MISMATCH',
    //       message: '인증번호가 일치하지 않습니다.',
    //     ),
    //     phone: code.phone,
    //   );
    // }
  }
}
