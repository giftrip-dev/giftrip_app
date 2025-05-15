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
}
