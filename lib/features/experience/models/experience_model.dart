import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/experience/models/experience_category.dart';
import 'package:giftrip/features/home/models/product_model.dart';

/// 체험 상품 모델
class ExperienceModel {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final int originalPrice;
  final int finalPrice;
  final int? discountRate;
  final ExperienceCategory category;
  final double rating;
  final int reviewCount;
  final List<ProductTagType> badges;
  final DateTime availableFrom; // 구매 가능 시작일
  final DateTime availableTo; // 구매 가능 종료일
  final bool soldOut; // 품절 여부
  final List<String>? unavailableDates; // 이용 불가능 날짜 목록

  const ExperienceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.originalPrice,
    required this.finalPrice,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.badges,
    required this.availableFrom,
    required this.availableTo,
    this.discountRate,
    this.soldOut = false, // 기본값은 품절 아님
    this.unavailableDates,
  });

  /// 할인이 적용되었는지 여부
  bool get hasDiscount => discountRate != null && discountRate! > 0;

  /// 현재 구매 가능한지 여부
  bool get isAvailableToPurchase {
    if (soldOut) return false; // 품절인 경우 구매 불가
    final now = DateTime.now();
    return now.isAfter(availableFrom) && now.isBefore(availableTo);
  }

  /// 특정 날짜에 이용 가능한지 여부
  bool isAvailableOnDate(DateTime date) {
    // 1. 품절 체크
    if (soldOut) return false;

    // 2. 구매 가능 기간 체크
    if (date.isBefore(availableFrom) || date.isAfter(availableTo)) {
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
  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      originalPrice: json['originalPrice'] as int,
      finalPrice: json['finalPrice'] as int,
      category: ExperienceCategory.fromString(json['category'] as String) ??
          ExperienceCategory.food,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      discountRate: json['discountRate'] as int?,
      badges: (json['badges'] as List<dynamic>?)
              ?.map((e) => ProductTagType.values.firstWhere(
                    (type) => type.name == e.toString().toUpperCase(),
                    orElse: () => ProductTagType.newArrival,
                  ))
              .toList() ??
          [],
      availableFrom: DateTime.parse(json['availableFrom'] as String),
      availableTo: DateTime.parse(json['availableTo'] as String),
      soldOut: json['soldOut'] as bool? ?? false,
      unavailableDates: (json['unavailableDates'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  /// Experience -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'originalPrice': originalPrice,
      'finalPrice': finalPrice,
      'category': category.name,
      'rating': rating,
      'reviewCount': reviewCount,
      'discountRate': discountRate,
      'badges': badges.map((e) => e.name).toList(),
      'availableFrom': availableFrom.toIso8601String(),
      'availableTo': availableTo.toIso8601String(),
      'soldOut': soldOut,
      'unavailableDates': unavailableDates,
    };
  }
}

/// 페이징 응답
class ExperiencePageResponse {
  final List<ExperienceModel> items;
  final PageMeta meta;

  ExperiencePageResponse({
    required this.items,
    required this.meta,
  });

  factory ExperiencePageResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>;
    return ExperiencePageResponse(
      items: itemsJson.map((e) => ExperienceModel.fromJson(e)).toList(),
      meta: PageMeta.fromJson(json['meta']),
    );
  }
}
