import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/event/models/event_model.dart';
import 'package:giftrip/features/event/repositories/mock_event_data.dart';

class EventRepo {
  final Dio _dio = DioClient().to();

  /// 이벤트 목록 조회
  Future<EventPageResponse> getEventList({
    int page = 1,
    int limit = 10,
  }) async {
    // 목업 데이터를 불러오는 동안 0.3초 딜레이
    await Future.delayed(const Duration(milliseconds: 300));

    // 목업 데이터 사용
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    // 데이터가 범위를 벗어나지 않도록 체크
    if (startIndex >= mockEventList.length) {
      return EventPageResponse(
        items: [],
        meta: PageMeta(
          currentPage: page,
          totalPages: (mockEventList.length / limit).ceil(),
          totalItems: mockEventList.length,
          itemsPerPage: limit,
        ),
      );
    }

    final items = mockEventList.sublist(
      startIndex,
      endIndex > mockEventList.length ? mockEventList.length : endIndex,
    );

    return EventPageResponse(
      items: items,
      meta: PageMeta(
        currentPage: page,
        totalPages: (mockEventList.length / limit).ceil(),
        totalItems: mockEventList.length,
        itemsPerPage: limit,
      ),
    );

    // todo: API 호출 코드 (나중에 사용)
    /*try {
      final response = await _dio.get('/api/events', queryParameters: {
        'page': page,
        'limit': limit,
      });

      if (response.statusCode == 200) {
        return EventPageResponse.fromJson(response.data);
      } else {
        throw Exception('이벤트 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('이벤트 조회 API 요청 실패: $e');
    }*/
  }
}
