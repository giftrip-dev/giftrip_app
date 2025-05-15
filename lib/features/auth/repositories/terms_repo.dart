import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/core/services/storage_service.dart';
import 'package:giftrip/features/auth/models/terms_model.dart';

class TermsRepository {
  final Dio _dio = DioClient().to();

  // 약관 동의 업데이트
  Future<TermsAgreementResponse> updateTermsAgreement(
      TermsAgreementRequest request) async {
    try {
      // TODO: 실제 API 구현 시 아래 주석 해제
      // final response = await _dio.post(
      //   '/api/auth/terms-agreement',
      //   data: request.toJson(),
      // );
      //
      // if (response.statusCode == 201) {
      //   final data = response.data;
      //   await GlobalStorage().setServiceTermsComplete();
      //   return TermsAgreementResponse.fromJson(data);
      // } else {
      //   return TermsAgreementResponse(
      //     isSuccess: false,
      //     errorMessage: '약관 동의 업데이트에 실패했습니다.',
      //   );
      // }

      // 임시: 성공으로 처리
      await GlobalStorage().setServiceTermsComplete();
      return TermsAgreementResponse(
        isSuccess: true,
        userId: 'temp_user_id',
      );
    } catch (e) {
      return TermsAgreementResponse(
        isSuccess: false,
        errorMessage: '약관 동의 중 오류가 발생했습니다.',
      );
    }
  }

  // 약관 동의 상태 조회
  Future<TermsAgreementResponse> getTermsAgreementStatus() async {
    try {
      // TODO: 실제 API 구현 시 아래 주석 해제
      // final response = await _dio.get('/api/auth/terms-agreement');
      // return TermsAgreementResponse.fromJson(response.data);

      // 임시: 항상 동의하지 않은 상태로 처리
      return TermsAgreementResponse(
        isSuccess: true,
        userId: 'temp_user_id',
      );
    } catch (e) {
      return TermsAgreementResponse(
        isSuccess: false,
        errorMessage: '약관 동의 상태 조회 중 오류가 발생했습니다.',
      );
    }
  }
}
