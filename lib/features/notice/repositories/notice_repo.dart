import 'package:dio/dio.dart';
import 'package:myong/core/services/api_service.dart';
import 'package:myong/features/notice/models/notice_model.dart';

class NoticeRepo {
  final Dio _dio = DioClient().to();

  /// 공지사항 목록 조회
  Future<NoticeResponse> getNoticeList({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get('/api/announcements', queryParameters: {
        'page': page,
        'limit': limit,
      });

      if (response.statusCode == 200) {
        return NoticeResponse.fromJson(response.data);
      } else {
        throw Exception('공지사항 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('공지사항 조회 API 요청 실패: $e');
    }
  }
}
