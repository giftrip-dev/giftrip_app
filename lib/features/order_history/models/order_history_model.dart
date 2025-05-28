import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/core/utils/page_meta.dart';

/// 예약 진행 상태
enum OrderBookingProgress {
  confirmed, // 예약/구매 완료
  completed, // 사용/배송 완료
  canceled; // 취소
}

/// 구매 내역 상품 모델 (개별 상품)
class OrderHistoryItemModel {
  final String id;
  final String productId;
  final String title;
  final String thumbnailUrl;
  final int originalPrice;
  final int finalPrice;
  final int? discountRate;
  final ProductItemType category;
  final int quantity;

  const OrderHistoryItemModel({
    required this.id,
    required this.productId,
    required this.title,
    required this.thumbnailUrl,
    required this.originalPrice,
    required this.finalPrice,
    required this.category,
    required this.quantity,
    this.discountRate,
  });

  /// 할인이 적용되었는지 여부
  bool get hasDiscount => discountRate != null && discountRate! > 0;

  /// 해당 상품의 총 금액
  int get totalPrice => finalPrice * quantity;

  factory OrderHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return OrderHistoryItemModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      originalPrice: json['originalPrice'] as int,
      finalPrice: json['finalPrice'] as int,
      category: ProductItemType.fromString(json['category'] as String) ??
          ProductItemType.product,
      quantity: json['quantity'] as int,
      discountRate: json['discountRate'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'originalPrice': originalPrice,
      'finalPrice': finalPrice,
      'category': category.value,
      'quantity': quantity,
      'discountRate': discountRate,
    };
  }
}

/// 구매 내역 모델 (주문 단위)
class OrderBookingModel {
  final String id;
  final String orderName; // 주문명 (예: "제주 감귤 선물세트 외 2개")
  final List<OrderHistoryItemModel> items; // 주문 상품 목록
  final int totalAmount; // 총 주문 금액
  final OrderBookingProgress progress; // 예약 진행 상태
  final DateTime paidAt; // 결제 완료 날짜
  final String transactionId; // 거래 ID

  const OrderBookingModel({
    required this.id,
    required this.orderName,
    required this.items,
    required this.totalAmount,
    required this.progress,
    required this.paidAt,
    required this.transactionId,
  });

  /// 주 카테고리 (첫 번째 상품의 카테고리)
  ProductItemType get primaryCategory => items.first.category;

  /// 상품 종류 개수
  int get itemCount => items.length;

  /// 전체 수량
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  /// 할인이 적용되었는지 여부
  bool get hasDiscount => items.any((item) => item.hasDiscount);

  factory OrderBookingModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>;
    return OrderBookingModel(
      id: json['id'] as String,
      orderName: json['orderName'] as String,
      items: itemsJson.map((e) => OrderHistoryItemModel.fromJson(e)).toList(),
      totalAmount: json['totalAmount'] as int,
      progress: OrderBookingProgress.values.firstWhere(
        (e) => e.name == json['progress'],
        orElse: () => OrderBookingProgress.confirmed,
      ),
      paidAt: DateTime.parse(json['paidAt'] as String),
      transactionId: json['transactionId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderName': orderName,
      'items': items.map((e) => e.toJson()).toList(),
      'totalAmount': totalAmount,
      'progress': progress.name,
      'paidAt': paidAt.toIso8601String(),
      'transactionId': transactionId,
    };
  }
}

/// 페이징 응답
class OrderBookingPageResponse {
  final List<OrderBookingModel> items;
  final PageMeta meta;

  OrderBookingPageResponse({
    required this.items,
    required this.meta,
  });

  factory OrderBookingPageResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>;
    return OrderBookingPageResponse(
      items: itemsJson.map((e) => OrderBookingModel.fromJson(e)).toList(),
      meta: PageMeta.fromJson(json['meta']),
    );
  }
}
