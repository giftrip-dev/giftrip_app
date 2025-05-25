import 'package:flutter/foundation.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/features/cart/models/cart_item_model.dart';
import 'package:giftrip/features/cart/repositories/cart_repo.dart';
import 'package:giftrip/features/cart/models/cart_category.dart';

class CartViewModel extends ChangeNotifier {
  final CartRepo _repo = CartRepo();

  // 상태 저장
  List<CartItemModel> _cartItems = [];
  PageMeta? _meta;
  bool _isLoading = false;
  bool _hasError = false;
  CartCategory? _selectedCategory;

  // 선택된 아이템 id 목록
  final Set<String> _selectedItemIds = {};
  Set<String> get selectedItemIds => _selectedItemIds;

  // Getters
  List<CartItemModel> get cartItems => _cartItems;
  int get cartItemCount => _cartItems.length;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  CartCategory? get selectedCategory => _selectedCategory;

  /// 다음 페이지 번호 계산
  int? get nextPage {
    if (_meta == null) return null;
    return _meta!.currentPage < _meta!.totalPages
        ? _meta!.currentPage + 1
        : null;
  }

  /// 장바구니 초기화 (앱 시작시 호출)
  Future<void> initialize() async {
    await fetchCartItems();
  }

  /// 카테고리 변경
  Future<void> changeCategory(CartCategory? category) async {
    if (_selectedCategory == category) return;

    // 로딩 상태 시작
    _isLoading = true;
    _cartItems = [];
    notifyListeners();

    // 0.2초 딜레이
    await Future.delayed(const Duration(milliseconds: 200));

    _selectedCategory = category;
    await fetchCartItems(refresh: true);
  }

  /// 장바구니 목록 조회
  Future<void> fetchCartItems({bool refresh = false}) async {
    // 이미 로딩 중이거나, 첫 로드/새로고침이 아닌데 다음 페이지가 없는 경우 리턴
    logger.d('refresh: $refresh');
    if ((!refresh && _isLoading) ||
        (!refresh && _cartItems.isNotEmpty && nextPage == null)) {
      return;
    }

    try {
      if (!refresh) {
        _isLoading = true;
        notifyListeners();
      }
      logger.d('fetchCartItems');
      // 새로고침이거나 첫 로드인 경우 페이지 1부터 시작
      final page = refresh || _cartItems.isEmpty ? 1 : (nextPage ?? 1);

      final response = await _repo.getCartItems();

      if (refresh || _cartItems.isEmpty) {
        _cartItems = response;
      } else {
        _cartItems = [..._cartItems, ...response];
      }
      _hasError = false;
    } catch (e) {
      _hasError = true;
      logger.e('체험 상품 목록 조회 실패: $e');
    } finally {
      _isLoading = false;
      logger.d('fetchCartItems end');
      notifyListeners();
    }
  }

  /// 장바구니에 상품 추가
  Future<void> addToCart(String productId, ProductItemType type,
      {int quantity = 1}) async {
    try {
      logger.d('장바구니 추가 시작: $productId, $type, $quantity');
      _isLoading = true;
      notifyListeners();

      await _repo.addToCart(productId, type, quantity: quantity);
      logger.d('장바구니 추가 완료, 목록 갱신 시작');

      // 장바구니 목록을 다시 가져와서 UI 업데이트
      await fetchCartItems(refresh: true);
      logger.d('장바구니 목록 갱신 완료, 현재 아이템 수: ${_cartItems.length}');

      _hasError = false;
    } catch (e) {
      _hasError = true;
      logger.e('장바구니 추가 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 장바구니에서 상품 제거
  Future<void> removeFromCart(String itemId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _repo.removeFromCart(itemId);

      // 장바구니 목록을 다시 가져와서 UI 업데이트
      await fetchCartItems(refresh: true);
      _hasError = false;
    } catch (e) {
      _hasError = true;
      logger.e('장바구니 제거 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 선택 관련 메서드
  void toggleSelectItem(String itemId) {
    if (_selectedItemIds.contains(itemId)) {
      _selectedItemIds.remove(itemId);
    } else {
      _selectedItemIds.add(itemId);
    }
    notifyListeners();
  }

  void selectAll() {
    _selectedItemIds.clear();
    _selectedItemIds.addAll(_cartItems.map((e) => e.id));
    notifyListeners();
  }

  void deselectAll() {
    _selectedItemIds.clear();
    notifyListeners();
  }

  bool isAllSelected() {
    return _cartItems.isNotEmpty &&
        _selectedItemIds.length == _cartItems.length;
  }

  bool isItemSelected(String itemId) {
    return _selectedItemIds.contains(itemId);
  }

  // 수량 변경 메서드
  void changeQuantity(String itemId, int newQuantity) {
    final idx = _cartItems.indexWhere((e) => e.id == itemId);
    if (idx != -1) {
      final item = _cartItems[idx];
      // 모든 카테고리에서 수량 변경 허용
      _cartItems[idx] = item.copyWith(quantity: newQuantity);
      notifyListeners();
    }
  }

  // 섹션별 전체선택/해제
  void selectAllByCategories(List<CartCategory> categories) {
    _selectedItemIds.addAll(_cartItems
        .where((e) => categories.contains(e.category))
        .map((e) => e.id));
    notifyListeners();
  }

  void deselectAllByCategories(List<CartCategory> categories) {
    _selectedItemIds.removeWhere((id) {
      final item = _cartItems.where((e) => e.id == id).toList();
      if (item.isEmpty) return false;
      return categories.contains(item.first.category);
    });
    notifyListeners();
  }

  bool isAllSelectedByCategories(List<CartCategory> categories) {
    final sectionIds = _cartItems
        .where((e) => categories.contains(e.category))
        .map((e) => e.id)
        .toSet();
    return sectionIds.isNotEmpty && _selectedItemIds.containsAll(sectionIds);
  }
}
