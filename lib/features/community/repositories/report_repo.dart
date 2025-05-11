import 'package:dio/dio.dart';
import 'package:myong/core/services/api_service.dart';
import 'package:myong/features/community/models/dto/report_dto.dart';

class ReportResponse {
  final bool isSuccess;
  final int code;

  ReportResponse({
    required this.isSuccess,
    required this.code,
  });
}

class ReportRepo {
  final Dio _dio = DioClient().to();

  Future<ReportResponse> reportContent(ReportDto reportDto) async {
    try {
      await _dio.post(
        '/api/reports',
        data: reportDto.toJson(),
      );

      return ReportResponse(isSuccess: true, code: 201);
    } catch (e) {
      final statusCode = (e as DioException).response?.statusCode ?? 500;

      print('신고 요청 실패: $e');
      return ReportResponse(isSuccess: false, code: statusCode);
    }
  }
}
