import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/features/cart/models/cart_item_model.dart';

class CartRepo {
  final Dio _dio = DioClient().to();

  // 목업 데이터
  final List<CartItemModel> _mockCartItems = [
    CartItemModel(
      id: '1',
      productId: 'product1',
      title: '유기농 사과 3kg',
      thumbnailUrl: 'assets/png/mock_product1.png',
      price: 25000,
      quantity: 1,
      type: ProductItemType.product,
      addedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    CartItemModel(
      id: '2',
      productId: 'experience1',
      title: '제주 감귤 따기 체험',
      thumbnailUrl: 'assets/png/mock_experience1.png',
      price: 35000,
      quantity: 2,
      type: ProductItemType.experience,
      addedAt: DateTime.now(),
    ),
  ];

  /// 장바구니 목록 조회
  Future<List<CartItemModel>> getCartItems() async {
    // API 호출 코드 (실제 구현시 주석 해제)
    /*try {
      final response = await _dio.get('/api/cart');
      
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data['items'];
        return items.map((item) => CartItemModel.fromJson(item)).toList();
      } else {
        throw Exception('장바구니 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('장바구니 API 요청 실패: $e');
    }*/

    // 목업 데이터 사용 (0.2초 딜레이)
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockCartItems;
  }

  /// 장바구니에 상품 추가
  Future<void> addToCart(String productId, ProductItemType type,
      {int quantity = 1}) async {
    // API 호출 코드 (실제 구현시 주석 해제)
    /*try {
      final response = await _dio.post('/api/cart', data: {
        'productId': productId,
        'type': type.value,
        'quantity': quantity,
      });
      
      if (response.statusCode != 200) {
        throw Exception('장바구니 추가 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('장바구니 API 요청 실패: $e');
    }*/

    // 목업 데이터 사용 (0.2초 딜레이)
    await Future.delayed(const Duration(milliseconds: 200));
  }

  /// 장바구니에서 상품 제거
  Future<void> removeFromCart(String itemId) async {
    // API 호출 코드 (실제 구현시 주석 해제)
    /*try {
      final response = await _dio.delete('/api/cart/$itemId');
      
      if (response.statusCode != 200) {
        throw Exception('장바구니 제거 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('장바구니 API 요청 실패: $e');
    }*/

    // 목업 데이터 사용 (0.2초 딜레이)
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
