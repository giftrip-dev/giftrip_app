import 'package:dio/dio.dart';
import 'package:myong/core/utils/logger.dart';
import 'package:myong/features/user/models/dto/certificates_dto.dart';
import 'package:myong/core/services/api_service.dart';
import 'package:myong/features/user/models/certificate_model.dart';

class CertificateRepository {
  final Dio _dio = DioClient().to();

  /// 직군 인증 신청
  Future<void> postCertificate(CertificatesUpdateRequestDto dto) async {
    try {
      Response response = await _dio.post(
        "/api/certificates",
        data: dto.toJson(),
      );

      if (response.statusCode == 201) {
        logger.i("직군 인증 신청 성공: ${response.data}");
      } else {
        logger.e("직군 인증 신청 실패: ${response.statusCode}");
      }
    } catch (e) {
      logger.e("직군 인증 신청 요청 실패: $e");
    }
  }

  /// 직군 인증 조회
  Future<List<CertificateModel>?> getCertificate() async {
    try {
      final response = await _dio.get("/api/certificates/me");
      if (response.statusCode == 200) {
        logger.i("직군 인증 조회 성공: ${response.data}");
        return (response.data as List)
            .map((json) => CertificateModel.fromJson(json))
            .toList();
      } else {
        throw Exception('직군 인증 조회 API 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('직군 인증 조회 API 요청 실패: $e');
    }
  }
}
