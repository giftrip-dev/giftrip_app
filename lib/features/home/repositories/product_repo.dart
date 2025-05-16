import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/features/home/models/product_model.dart';

class ProductRepo {
  final Dio _dio = DioClient().to();

  /// 새상품 목록 조회
  Future<ProductPageResponse> getNewProductList({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get('/api/posts', queryParameters: {
        'page': page,
        'limit': limit,
      });

      if (response.statusCode == 200) {
        return ProductPageResponse.fromJson(response.data);
      } else {
        throw Exception('게시글 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('게시글 조회 API 요청 실패: $e');
    }
  }

  /// 베스트 상품 목록 조회
  Future<ProductPageResponse> getBestProductList({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get('/api/posts', queryParameters: {
        'page': page,
        'limit': limit,
      });

      if (response.statusCode == 200) {
        return ProductPageResponse.fromJson(response.data);
      } else {
        throw Exception('게시글 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('게시글 조회 API 요청 실패: $e');
    }
  }

  /// 관련 상품 목록 조회
  /// [productType] - 상품 타입에 따라 적절한 관련 상품 목록을 조회
  /// [productId] - 현재 보고 있는 상품 ID (관련 상품 추천 시 제외하기 위함)
  Future<ProductPageResponse> getRelatedProducts({
    required ProductType productType,
    String? productId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response =
          await _dio.get('/api/products/related', queryParameters: {
        'type': productType.toString().split('.').last,
        'productId': productId,
        'page': page,
        'limit': limit,
      });

      if (response.statusCode == 200) {
        return ProductPageResponse.fromJson(response.data);
      } else {
        throw Exception('관련 상품 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('관련 상품 조회 API 요청 실패: $e');
    }
  }

  /// 상품 구매 가능 여부 확인
  /// [productType] - 상품 타입 (숙소, 체험, 체험단 등)
  /// [productId] - 상품 ID
  /// [startDate] - 이용 시작일
  /// [endDate] - 이용 종료일
  /// [personCount] - 인원 수 (숙소의 경우 필수, 체험/체험단은 옵션)
  Future<bool> checkProductAvailability({
    required ProductType productType,
    required String productId,
    required DateTime startDate,
    required DateTime endDate,
    int? personCount,
  }) async {
    // 서버 통신 부분 (추후 구현)
    /*
    try {
      final response = await _dio.get('/api/products/availability', queryParameters: {
        'type': productType.toString().split('.').last,
        'productId': productId,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        if (personCount != null) 'personCount': personCount,
      });

      if (response.statusCode == 200) {
        return response.data['isAvailable'] as bool;
      } else {
        throw Exception('상품 구매 가능 여부 확인 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('상품 구매 가능 여부 확인 API 요청 실패: $e');
    }
    */

    // 목업 데이터: 항상 구매 가능으로 반환
    await Future.delayed(const Duration(milliseconds: 300)); // API 호출 시뮬레이션
    return true;
  }
}
