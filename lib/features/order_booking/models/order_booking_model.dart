import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/order_booking/models/order_booking_category.dart';

/// 예약 진행 상태
enum OrderBookingProgress {
  confirmed, // 예약/구매 완료
  completed, // 사용/배송 완료
  canceled; // 취소
}

/// 체험 상품 모델
class OrderBookingModel {
  final String id;
  final String title;
  final String thumbnailUrl;
  final int originalPrice;
  final int finalPrice;
  final int? discountRate;
  final OrderBookingCategory category;
  final double rating;
  final int reviewCount;
  final DateTime? availableFrom; // 구매 가능 시작일
  final DateTime? availableTo; // 구매 가능 종료일
  final bool soldOut; // 품절 여부
  final List<String>? unavailableDates; // 이용 불가능 날짜 목록
  final OrderBookingProgress progress; // 예약 진행 상태
  final DateTime paidAt; // 결제 완료 날짜

  const OrderBookingModel({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.originalPrice,
    required this.finalPrice,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.availableFrom,
    required this.availableTo,
    required this.progress,
    this.discountRate,
    this.soldOut = false, // 기본값은 품절 아님
    this.unavailableDates,
    required this.paidAt,
  });

  /// 할인이 적용되었는지 여부
  bool get hasDiscount => discountRate != null && discountRate! > 0;

  /// 현재 구매 가능한지 여부
  bool get isAvailableToPurchase {
    if (soldOut) return false; // 품절인 경우 구매 불가
    final now = DateTime.now();
    return now.isAfter(availableFrom ?? DateTime.now()) &&
        now.isBefore(availableTo ?? DateTime.now());
  }

  /// 특정 날짜에 이용 가능한지 여부
  bool isAvailableOnDate(DateTime date) {
    // 1. 품절 체크
    if (soldOut) return false;

    // 2. 구매 가능 기간 체크
    if (date.isBefore(availableFrom ?? DateTime.now()) ||
        date.isAfter(availableTo ?? DateTime.now())) {
      return false;
    }

    // 3. 불가능 날짜 목록 체크
    if (unavailableDates != null) {
      final dateString = date.toIso8601String().split('T')[0]; // YYYY-MM-DD 형식
      return !unavailableDates!.contains(dateString);
    }

    return true;
  }

  /// JSON -> Experience Model
  factory OrderBookingModel.fromJson(Map<String, dynamic> json) {
    return OrderBookingModel(
      id: json['id'] as String,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      originalPrice: json['originalPrice'] as int,
      finalPrice: json['finalPrice'] as int,
      category: OrderBookingCategory.fromString(json['category'] as String) ??
          OrderBookingCategory.lodging,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      discountRate: json['discountRate'] as int?,
      availableFrom: DateTime.parse(json['availableFrom'] as String),
      availableTo: DateTime.parse(json['availableTo'] as String),
      soldOut: json['soldOut'] as bool? ?? false,
      unavailableDates: (json['unavailableDates'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      progress: OrderBookingProgress.values.firstWhere(
        (e) => e.name == json['progress'],
        orElse: () => OrderBookingProgress.confirmed,
      ),
      paidAt: DateTime.parse(json['paidAt'] as String),
    );
  }

  /// Experience -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'originalPrice': originalPrice,
      'finalPrice': finalPrice,
      'category': category.name,
      'rating': rating,
      'reviewCount': reviewCount,
      'discountRate': discountRate,
      'availableFrom': availableFrom?.toIso8601String(),
      'availableTo': availableTo?.toIso8601String(),
      'soldOut': soldOut,
      'unavailableDates': unavailableDates,
      'progress': progress.name,
      'paidAt': paidAt?.toIso8601String(),
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
