import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/shopping/models/shopping_category.dart';
import 'package:giftrip/features/home/models/product_model.dart';

/// 쇼핑 상품 모델
class ShoppingModel {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final int originalPrice;
  final int finalPrice;
  final int? discountRate;
  final ShoppingCategory category;
  final double rating;
  final int reviewCount;
  final List<ProductTagType> badges;
  final String manufacturer; // 제조사
  final bool soldOut; // 품절 여부

  const ShoppingModel({
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
    required this.manufacturer,
    this.discountRate,
    this.soldOut = false, // 기본값은 품절 아님
  });

  /// 할인이 적용되었는지 여부
  bool get hasDiscount => discountRate != null && discountRate! > 0;

  /// 현재 구매 가능한지 여부
  bool get isAvailableToPurchase => !soldOut;

  /// JSON -> Shopping Model
  factory ShoppingModel.fromJson(Map<String, dynamic> json) {
    return ShoppingModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      originalPrice: json['originalPrice'] as int,
      finalPrice: json['finalPrice'] as int,
      category: ShoppingCategory.fromString(json['category'] as String) ??
          ShoppingCategory.others,
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
      manufacturer: json['manufacturer'] as String,
      soldOut: json['soldOut'] as bool? ?? false,
    );
  }

  /// Shopping -> JSON
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
      'manufacturer': manufacturer,
      'soldOut': soldOut,
    };
  }
}

/// 페이징 응답
class ShoppingPageResponse {
  final List<ShoppingModel> items;
  final PageMeta meta;

  ShoppingPageResponse({
    required this.items,
    required this.meta,
  });

  factory ShoppingPageResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>;
    return ShoppingPageResponse(
      items: itemsJson.map((e) => ShoppingModel.fromJson(e)).toList(),
      meta: PageMeta.fromJson(json['meta']),
    );
  }
}
