import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/features/cart/models/cart_item_model.dart';
import 'package:giftrip/features/cart/models/cart_category.dart';
import 'package:giftrip/features/shopping/repositories/mock_shopping_data.dart';
import 'package:giftrip/features/experience/repositories/mock_experience_data.dart';
import 'package:giftrip/features/lodging/repositories/mock_lodging_data.dart';
import 'package:giftrip/features/tester/repositories/mock_tester_data.dart';

class CartRepo {
  final Dio _dio = DioClient().to();

  // 목업 환경 여부 (실제 배포시 false로 변경)
  static const bool _useMockData = true;

  // 목업 데이터용 로컬 상태
  static List<CartItemModel> _mockCartItems = [];

  /// 장바구니 목록 조회
  Future<List<CartItemModel>> getCartItems() async {
    if (_useMockData) {
      // 목업 데이터 사용
      await Future.delayed(const Duration(milliseconds: 200));
      return List.from(_mockCartItems);
    } else {
      // 실제 API 호출
      try {
        final response = await _dio.get('/api/cart');

        if (response.statusCode == 200) {
          final List<dynamic> items = response.data['items'];
          return items.map((item) => CartItemModel.fromJson(item)).toList();
        } else {
          throw Exception('장바구니 조회 실패: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('장바구니 API 요청 실패: $e');
      }
    }
  }

  /// 장바구니에 상품 추가
  Future<void> addToCart(String productId, ProductItemType type,
      {int quantity = 1, DateTime? startDate, DateTime? endDate}) async {
    if (_useMockData) {
      // 목업 데이터 사용
      await Future.delayed(const Duration(milliseconds: 200));

      // 상품 타입에 따라 해당 목업 데이터에서 상품 찾기
      CartItemModel? cartItem;

      switch (type) {
        case ProductItemType.product:
          final product = mockShoppingList.firstWhere(
            (item) => item.id == productId,
            orElse: () => throw Exception('상품을 찾을 수 없습니다: $productId'),
          );
          cartItem = CartItemModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            productId: productId,
            category: CartCategory.product,
            title: product.title,
            thumbnailUrl: product.thumbnailUrl,
            originalPrice: product.originalPrice,
            price: product.finalPrice,
            discountRate: product.discountRate,
            quantity: quantity,
            type: type,
            addedAt: DateTime.now(),
            tags: product.badges.map((badge) => badge.name).toList(),
            options:
                product.options.isNotEmpty ? product.options.first.name : null,
          );
          break;

        case ProductItemType.experience:
          final experience = mockExperienceList.firstWhere(
            (item) => item.id == productId,
            orElse: () => throw Exception('체험 상품을 찾을 수 없습니다: $productId'),
          );
          cartItem = CartItemModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            productId: productId,
            category: CartCategory.experience,
            title: experience.title,
            thumbnailUrl: experience.thumbnailUrl,
            originalPrice: experience.originalPrice,
            price: experience.finalPrice,
            discountRate: experience.discountRate,
            quantity: quantity,
            type: type,
            addedAt: DateTime.now(),
            tags: experience.badges.map((badge) => badge.name).toList(),
            startDate: startDate,
            endDate: endDate,
          );
          break;

        case ProductItemType.lodging:
          final lodging = mockLodgingList.firstWhere(
            (item) => item.id == productId,
            orElse: () => throw Exception('숙소 상품을 찾을 수 없습니다: $productId'),
          );
          cartItem = CartItemModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            productId: productId,
            category: CartCategory.lodging,
            title: lodging.title,
            thumbnailUrl: lodging.thumbnailUrl,
            originalPrice: lodging.originalPrice,
            price: lodging.finalPrice,
            discountRate: lodging.discountRate,
            quantity: quantity,
            type: type,
            addedAt: DateTime.now(),
            tags: lodging.badges.map((badge) => badge.name).toList(),
            startDate: startDate,
            endDate: endDate,
          );
          break;

        case ProductItemType.experienceGroup:
          final tester = mockTesterList.firstWhere(
            (item) => item.id == productId,
            orElse: () => throw Exception('체험단 상품을 찾을 수 없습니다: $productId'),
          );
          cartItem = CartItemModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            productId: productId,
            category: CartCategory.experienceGroup,
            title: tester.title,
            thumbnailUrl: tester.thumbnailUrl,
            originalPrice: tester.originalPrice,
            price: tester.finalPrice,
            discountRate: tester.discountRate,
            quantity: quantity,
            type: type,
            addedAt: DateTime.now(),
            tags: tester.badges.map((badge) => badge.name).toList(),
            startDate: startDate,
            endDate: endDate,
          );
          break;

        default:
          throw Exception('지원하지 않는 상품 타입입니다: $type');
      }

      _mockCartItems.add(cartItem);
    } else {
      // 실제 API 호출
      try {
        final response = await _dio.post('/api/cart', data: {
          'productId': productId,
          'type': type.value,
          'quantity': quantity,
          'startDate': startDate?.toIso8601String(),
          'endDate': endDate?.toIso8601String(),
        });

        if (response.statusCode != 200) {
          throw Exception('장바구니 추가 실패: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('장바구니 API 요청 실패: $e');
      }
    }
  }

  /// 장바구니에서 상품 제거
  Future<void> removeFromCart(String itemId) async {
    if (_useMockData) {
      // 목업 데이터 사용
      await Future.delayed(const Duration(milliseconds: 200));
      _mockCartItems.removeWhere((item) => item.id == itemId);
    } else {
      // 실제 API 호출
      try {
        final response = await _dio.delete('/api/cart/$itemId');

        if (response.statusCode != 200) {
          throw Exception('장바구니 제거 실패: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('장바구니 API 요청 실패: $e');
      }
    }
  }
}
