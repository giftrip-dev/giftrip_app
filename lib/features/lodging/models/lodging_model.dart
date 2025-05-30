import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/lodging/models/lodging_category.dart';
import 'package:giftrip/features/home/models/product_model.dart';

/// 숙박 상품 모델
class LodgingModel {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String mainLocation;
  final String subLocation;
  final String distanceInfo;
  final int originalPrice;
  final int finalPrice;
  final int? discountRate;
  final LodgingCategory category;
  final double rating;
  final double averageRating; // 평균 별점
  final int reviewCount;
  final List<ProductTagType> badges;
  final DateTime availableFrom; // 구매 가능 시작일
  final DateTime availableTo; // 구매 가능 종료일

  const LodgingModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.mainLocation,
    required this.subLocation,
    required this.distanceInfo,
    required this.originalPrice,
    required this.finalPrice,
    required this.category,
    required this.rating,
    required this.averageRating,
    required this.reviewCount,
    required this.badges,
    required this.availableFrom,
    required this.availableTo,
    this.discountRate,
  });

  /// 할인이 적용되었는지 여부
  bool get hasDiscount => discountRate != null && discountRate! > 0;

  /// 현재 구매 가능한지 여부
  bool get isAvailableToPurchase {
    final now = DateTime.now();
    return now.isAfter(availableFrom) && now.isBefore(availableTo);
  }

  /// JSON -> Lodging Model
  factory LodgingModel.fromJson(Map<String, dynamic> json) {
    return LodgingModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      mainLocation: json['mainLocation'] as String,
      subLocation: json['subLocation'] as String,
      distanceInfo: json['distanceInfo'] as String,
      originalPrice: json['originalPrice'] as int,
      finalPrice: json['finalPrice'] as int,
      category: LodgingCategory.fromString(json['category'] as String) ??
          LodgingCategory.hotel,
      rating: (json['rating'] as num).toDouble(),
      averageRating: (json['averageRating'] as num).toDouble(),
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
    );
  }

  /// Lodging -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'mainLocation': mainLocation,
      'subLocation': subLocation,
      'distanceInfo': distanceInfo,
      'originalPrice': originalPrice,
      'finalPrice': finalPrice,
      'category': category.name,
      'rating': rating,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      'discountRate': discountRate,
      'badges': badges.map((e) => e.name).toList(),
      'availableFrom': availableFrom.toIso8601String(),
      'availableTo': availableTo.toIso8601String(),
    };
  }
}

/// 페이징 응답
class LodgingPageResponse {
  final List<LodgingModel> items;
  final PageMeta meta;

  LodgingPageResponse({
    required this.items,
    required this.meta,
  });

  factory LodgingPageResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>;
    return LodgingPageResponse(
      items: itemsJson.map((e) => LodgingModel.fromJson(e)).toList(),
      meta: PageMeta.fromJson(json['meta']),
    );
  }
}
