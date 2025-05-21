import 'package:flutter/foundation.dart';
import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/features/cart/models/cart_item_model.dart';

/// 결제 예정 상품 모델
class PaymentItem {
  final String id;
  final String productId;
  final String title;
  final String thumbnailUrl;
  final int price;
  final int quantity;
  final ProductItemType type;

  const PaymentItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.thumbnailUrl,
    required this.price,
    required this.quantity,
    required this.type,
  });

  /// CartItemModel을 PaymentItem으로 변환
  factory PaymentItem.fromCartItem(CartItemModel item) {
    return PaymentItem(
      id: item.id,
      productId: item.productId,
      title: item.title,
      thumbnailUrl: item.thumbnailUrl,
      price: item.price,
      quantity: item.quantity,
      type: item.type,
    );
  }
}

/// 결제 뷰모델
class PaymentViewModel extends ChangeNotifier {
  List<PaymentItem> _items = [];
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  // Getters
  List<PaymentItem> get items => _items;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;

  /// 총 상품 금액
  int get totalProductPrice {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  /// 배송비
  int get shippingFee {
    return totalProductPrice < 30000 ? 2500 : 0;
  }

  /// 최종 결제 금액
  int get finalPrice {
    return totalProductPrice + shippingFee;
  }

  /// 결제 예정 상품 설정
  void setPaymentItems(List<PaymentItem> items) {
    _items = items;
    notifyListeners();
  }

  /// 결제 예정 상품 추가
  void addPaymentItem(PaymentItem item) {
    _items.add(item);
    notifyListeners();
  }

  /// 결제 예정 상품 제거
  void removePaymentItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  /// 결제 예정 상품 수량 변경
  void updateItemQuantity(String itemId, int quantity) {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      final item = _items[index];
      _items[index] = PaymentItem(
        id: item.id,
        productId: item.productId,
        title: item.title,
        thumbnailUrl: item.thumbnailUrl,
        price: item.price,
        quantity: quantity,
        type: item.type,
      );
      notifyListeners();
    }
  }

  /// 결제 프로세스 초기화
  void clear() {
    _items = [];
    _isLoading = false;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();
  }
}
