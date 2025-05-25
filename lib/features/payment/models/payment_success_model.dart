import 'package:giftrip/core/constants/item_type.dart';

class PaymentSuccessModel {
  final String orderId;
  final String orderName;
  final List<PaymentSuccessItem> items;
  final String paymentMethod;
  final int totalAmount;
  final int usedPoint;
  final int shippingFee;
  final DateTime paymentDate;

  const PaymentSuccessModel({
    required this.orderId,
    required this.orderName,
    required this.items,
    required this.paymentMethod,
    required this.totalAmount,
    required this.usedPoint,
    required this.shippingFee,
    required this.paymentDate,
  });

  /// 실제 결제 금액 (포인트 사용 후)
  int get actualPaymentAmount => totalAmount - usedPoint;

  /// 상품 금액 (배송비 제외)
  int get productAmount => totalAmount - shippingFee;

  /// 상품 주문인지 예약인지 판별 (첫 번째 아이템 기준)
  bool get isProductOrder =>
      items.isNotEmpty && items.first.type == ProductItemType.product;

  /// 완료 타이틀 텍스트
  String get completionTitle => isProductOrder ? '주문 완료' : '예약 완료';

  /// 완료 서브 텍스트
  String get completionSubtitle =>
      isProductOrder ? '빠르게 상품을 배송해드릴게요!' : '즐거운 시간이 여러분을 기다리고 있어요!';
}

class PaymentSuccessItem {
  final String title;
  final String optionName;
  final int quantity;
  final int price;
  final ProductItemType type;

  const PaymentSuccessItem({
    required this.title,
    required this.optionName,
    required this.quantity,
    required this.price,
    required this.type,
  });

  /// 해당 아이템의 총 금액
  int get totalPrice => price * quantity;
}
