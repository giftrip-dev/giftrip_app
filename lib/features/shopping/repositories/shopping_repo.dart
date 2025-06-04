import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/features/shopping/models/shopping_category.dart';
import 'package:giftrip/features/shopping/models/shopping_model.dart';
import 'package:giftrip/features/shopping/models/shopping_detail_model.dart';

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
        return ShoppingDetailModel.fromJson(response.data);
      } else {
        throw Exception('쇼핑 상품 상세 정보 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('쇼핑 상품 상세 정보 API 요청 실패: $e');
    }
  }
}
