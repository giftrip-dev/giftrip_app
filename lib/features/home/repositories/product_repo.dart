import 'package:dio/dio.dart';
import 'package:myong/core/services/api_service.dart';
import 'package:myong/features/home/models/product.dart';

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
}
