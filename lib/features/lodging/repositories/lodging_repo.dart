import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/lodging/models/lodging_category.dart';
import 'package:giftrip/features/lodging/models/lodging_model.dart';
import 'package:giftrip/features/lodging/models/lodging_detail_model.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/features/lodging/models/location.dart';

class LodgingRepo {
  final Dio _dio = DioClient().to();

  /// 숙박 상품 목록 조회
  Future<LodgingPageResponse> getLodgingList({
    String? mainLocation,
    String? subLocation,
    int page = 1,
    int limit = 10,
    String? category,
    String? createdAtStart,
    String? createdAtEnd,
    String? search,
  }) async {
    logger.d(
        'getLodgingList: mainLocation=$mainLocation, subLocation=$subLocation, page=$page, limit=$limit, category=$category, createdAtStart=$createdAtStart, createdAtEnd=$createdAtEnd, search=$search');
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      final response = await _dio.get(
        '/accommodations',
        queryParameters: {
          'mainLocation': mainLocation,
          'subLocation': subLocation,
          'page': page,
          'limit': limit,
          'category': category,
          'createdAtStart': createdAtStart,
          'createdAtEnd': createdAtEnd,
          'search': search,
        }..removeWhere((key, value) => value == null),
      );
      if (response.statusCode == 200) {
        return LodgingPageResponse.fromJson(response.data);
      } else {
        throw Exception('숙박 상품 조회 실패: [${response.statusCode}');
      }
    } catch (e) {
      throw Exception('숙박 상품 조회 API 요청 실패: $e');
    }
  }

  /// 숙박 상품 상세 정보 조회
  Future<LodgingDetailModel> getLodgingDetail(String id) async {
    try {
      final response = await _dio.get('/accommodations/$id');
      if (response.statusCode == 200) {
        return LodgingDetailModel.fromJson(response.data);
      } else {
        throw Exception('숙박 상품 상세 정보 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('숙박 상품 상세 정보 API 요청 실패: $e');
    }
  }
}
