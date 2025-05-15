import 'package:myong/core/utils/page_meta.dart';
import 'package:myong/features/experience/models/experience_category.dart';
import 'package:myong/features/home/models/product_model.dart';

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
  });

  /// 할인이 적용되었는지 여부
  bool get hasDiscount => discountRate != null && discountRate! > 0;

  /// 현재 구매 가능한지 여부
  bool get isAvailableToPurchase {
    final now = DateTime.now();
    return now.isAfter(availableFrom) && now.isBefore(availableTo);
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
