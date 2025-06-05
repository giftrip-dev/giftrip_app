import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/lodging/models/lodging_category.dart';
import 'package:giftrip/features/lodging/models/lodging_model.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/features/lodging/models/location.dart';
import 'package:giftrip/features/lodging/models/lodging_room_model.dart';

class LodgingRepo {
  final Dio _dio = DioClient().to();

  /// 예약가능 숙소업소 목록 조회
  Future<LodgingPageResponse> getAvailableLodgingList({
    String? startDate,
    String? endDate,
    String? mainLocation,
    String? subLocation,
    int? occupancy,
    String? category,
    bool? isActive,
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    logger.d(
        'getLodgingList: mainLocation=$mainLocation, subLocation=$subLocation, page=$page, limit=$limit, isActive=$isActive, category=$category, startDate=$startDate, endDate=$endDate, search=$search');
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      final response = await _dio.get(
        '/accommodations/available',
        queryParameters: {
          'startDate': startDate,
          'endDate': endDate,
          'mainLocation': mainLocation,
          'subLocation': subLocation,
          'occupancy': occupancy,
          'category': category,
          'isActive': isActive,
          'search': search,
          'page': page,
          'limit': limit,
        }..removeWhere((key, value) => value == null),
      );
      if (response.statusCode == 200) {
        return LodgingPageResponse.fromJson(response.data);
      } else {
        throw Exception('숙소 상품 조회 실패: [${response.statusCode}');
      }
    } catch (e) {
      throw Exception('숙소 상품 조회 API 요청 실패: $e');
    }
  }

  /// 숙소 상품 상세 정보 조회
  Future<LodgingModel> getLodgingDetail(String id) async {
    try {
      final response = await _dio.get('/accommodations/$id');
      if (response.statusCode == 200) {
        return LodgingModel.fromJson(response.data);
      } else {
        throw Exception('숙소 상품 상세 정보 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('숙소 상품 상세 정보 API 요청 실패: $e');
    }
  }

  /// 숙소업소 내 날짜 인원 별 객실 조회
  Future<LodgingRoomPageResponse> getAvailableRoomsForAccommodation({
    required String accommodationId,
    required String startDate,
    required String endDate,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dio.get(
        '/accommodations/rooms/$accommodationId/available',
        queryParameters: {
          'startDate': startDate,
          'endDate': endDate,
          'page': page,
          'limit': limit,
        },
      );
      if (response.statusCode == 200) {
        return LodgingRoomPageResponse.fromJson(response.data);
      } else {
        throw Exception('객실 조회 실패: [${response.statusCode}]');
      }
    } catch (e) {
      throw Exception('객실 조회 API 요청 실패: $e');
    }
  }
}
