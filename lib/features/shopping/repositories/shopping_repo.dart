import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/shopping/models/shopping_category.dart';
import 'package:giftrip/features/shopping/models/shopping_model.dart';
import 'package:giftrip/features/shopping/models/shopping_detail_model.dart';
import 'package:giftrip/features/home/models/product_model.dart';
import 'package:giftrip/features/shopping/models/shopping_related_product_model.dart';

class ShoppingRepo {
  final Dio _dio = DioClient().to();

  /// 쇼핑 상품 목록 조회
  Future<ShoppingPageResponse> getShoppingList({
    ShoppingCategory? category,
    int page = 1,
    int limit = 10,
  }) async {
    //  데이터를 불러오는 동안 0.3초 딜레이
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final response = await _dio.get('/products',
          queryParameters: {
            'category': category?.name,
            'page': page,
            'limit': limit,
          }..removeWhere((key, value) => value == null));

      if (response.statusCode == 200) {
        return ShoppingPageResponse.fromJson(response.data);
      } else {
        throw Exception('쇼핑 상품 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('쇼핑 상품 조회 API 요청 실패: $e');
    }
  }

  /// 쇼핑 상품 상세 정보 조회
  Future<ShoppingDetailModel> getShoppingDetail(String id) async {
    try {
      final response = await _dio.get('/products/$id');

      if (response.statusCode == 200) {
        logger.d('쇼핑 상품 상세 정보 조회 성공: ${response.data.toString()}');
        return ShoppingDetailModel.fromJson(response.data);
      } else {
        throw Exception('쇼핑 상품 상세 정보 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('쇼핑 상품 상세 정보 API 요청 실패: $e');
    }
  }

  /// 쇼핑 상품의 관련 상품 목록 조회
  Future<ProductPageResponse> getRelatedProducts({
    required String productId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/products/related/$productId',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        // List 형태의 응답을 ShoppingRelatedProductModel로 변환 후 ProductModel로 변환
        final items = (response.data as List)
            .map((item) => ShoppingRelatedProductModel.fromJson(item))
            .map((item) => item.toProductModel())
            .toList();

        return ProductPageResponse(
          items: items,
          meta: PageMeta(
            currentPage: page,
            totalPages: 1, // API에서 페이지 정보를 제공하지 않는 경우
            totalItems: items.length,
            itemsPerPage: limit,
          ),
        );
      } else {
        throw Exception('쇼핑 관련 상품 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('쇼핑 관련 상품 API 요청 실패: $e');
      throw Exception('쇼핑 관련 상품 API 요청 실패: $e');
    }
  }
}
