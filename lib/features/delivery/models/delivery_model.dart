import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/delivery/models/delivery_status.dart';

/// 체험 상품 모델
class DeliveryModel {
  final String id;
  final String title;
  final String thumbnailUrl;
  final int originalPrice;
  final int finalPrice;
  final int? discountRate;
  final DeliveryStatus status;
  final double rating;
  final int reviewCount;
  final DateTime? availableFrom; // 구매 가능 시작일
  final DateTime? availableTo; // 구매 가능 종료일
  final bool soldOut; // 품절 여부
  final List<String>? unavailableDates; // 이용 불가능 날짜 목록
  final DateTime paidAt; // 결제 완료 날짜
  final String option; // ex: '300g'
  final int quantity; // ex: 1

  const DeliveryModel({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.originalPrice,
    required this.finalPrice,
    required this.status,
    required this.rating,
    required this.reviewCount,
    required this.availableFrom,
    required this.availableTo,
    this.discountRate,
    this.soldOut = false, // 기본값은 품절 아님
    this.unavailableDates,
    required this.paidAt,
    required this.option,
    required this.quantity,
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
  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      originalPrice: json['originalPrice'] as int,
      finalPrice: json['finalPrice'] as int,
      status: DeliveryStatus.fromString(json['status'] as String) ??
          DeliveryStatus.preparing,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      discountRate: json['discountRate'] as int?,
      availableFrom: DateTime.parse(json['availableFrom'] as String),
      availableTo: DateTime.parse(json['availableTo'] as String),
      soldOut: json['soldOut'] as bool? ?? false,
      unavailableDates: (json['unavailableDates'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      paidAt: DateTime.parse(json['paidAt'] as String),
      option: json['option'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
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
      'status': status.name,
      'rating': rating,
      'reviewCount': reviewCount,
      'discountRate': discountRate,
      'availableFrom': availableFrom?.toIso8601String(),
      'availableTo': availableTo?.toIso8601String(),
      'soldOut': soldOut,
      'unavailableDates': unavailableDates,
      'paidAt': paidAt?.toIso8601String(),
      'option': option,
      'quantity': quantity,
    };
  }
}

/// 페이징 응답
class DeliveryPageResponse {
  final List<DeliveryModel> items;
  final PageMeta meta;

  DeliveryPageResponse({
    required this.items,
    required this.meta,
  });

  factory DeliveryPageResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>;
    return DeliveryPageResponse(
      items: itemsJson.map((e) => DeliveryModel.fromJson(e)).toList(),
      meta: PageMeta.fromJson(json['meta']),
    );
  }
}
