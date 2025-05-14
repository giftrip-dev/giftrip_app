import 'package:flutter/foundation.dart';
import 'package:myong/core/utils/logger.dart';
import 'package:myong/core/constants/item_type.dart';
import 'package:myong/features/cart/models/cart_item_model.dart';
import 'package:myong/features/cart/repositories/cart_repo.dart';

class CartViewModel extends ChangeNotifier {
  final CartRepo _repo = CartRepo();

  List<CartItemModel> _items = [];
  bool _isLoading = false;
  bool _hasError = false;

  // Getters
  List<CartItemModel> get items => _items;
  int get itemCount => _items.length;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  /// 장바구니 초기화 (앱 시작시 호출)
  Future<void> initialize() async {
    await fetchCartItems();
  }

  /// 장바구니 목록 조회
  Future<void> fetchCartItems() async {
    try {
      _isLoading = true;
      _hasError = false;
      notifyListeners();

      _items = await _repo.getCartItems();
    } catch (e) {
      _hasError = true;
      logger.e('장바구니 조회 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 장바구니에 상품 추가
  Future<void> addToCart(String productId, ProductItemType type,
      {int quantity = 1}) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _repo.addToCart(productId, type, quantity: quantity);
      await fetchCartItems(); // 장바구니 목록 갱신
    } catch (e) {
      _hasError = true;
      logger.e('장바구니 추가 실패: $e');
      notifyListeners();
    }
  }

  /// 장바구니에서 상품 제거
  Future<void> removeFromCart(String itemId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _repo.removeFromCart(itemId);
      await fetchCartItems(); // 장바구니 목록 갱신
    } catch (e) {
      _hasError = true;
      logger.e('장바구니 제거 실패: $e');
      notifyListeners();
    }
  }
}
