import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/features/auth/models/verification_code_model.dart';

class VerificationRepository {
  final Dio _dio = DioClient().to();

  // 인증 코드 전송
  Future<bool> sendVerificationCode(String phoneNumber, String type) async {
    // TODO: 실제 API 구현 시 아래 주석 해제
    // try {
    //   final response = await _dio.post(
    //     '/api/auth/verification/send',
    //     data: {
    //       'phoneNumber': phoneNumber,
    //       'type': type,
    //     },
    //   );
    //   return response.statusCode == 201;
    // } catch (e) {
    //   return false;
    // }

    // 임시: 항상 성공으로 처리
    return true;
  }

  // 인증 코드 검증
  Future<VerificationResult> verifyCode(VerificationCode code) async {
    // TODO: 실제 API 구현 시 아래 주석 해제
    // try {
    //   final response = await _dio.post(
    //     '/api/auth/verification/verify',
    //     data: code.toJson(),
    //   );
    //   if (response.statusCode == 201) {
    //     return VerificationResult(isVerified: true);
    //   } else {
    //     return VerificationResult(
    //       isVerified: false,
    //       errorMessage: '인증에 실패했습니다.',
    //     );
    //   }
    // } catch (e) {
    //   return VerificationResult(
    //     isVerified: false,
    //     errorMessage: '인증 중 오류가 발생했습니다.',
    //   );
    // }

    // 임시: 123456 코드로 통과
    if (code.code == '123456') {
      return VerificationResult(isVerified: true);
    } else {
      return VerificationResult(
        isVerified: false,
        errorMessage: '인증번호가 일치하지 않습니다.',
      );
    }
  }
}
