import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/shopping/models/shopping_category.dart';
import 'package:giftrip/features/home/models/product_model.dart';

/// 쇼핑 상품 모델
class ShoppingModel {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String manufacturer;
  final int originalPrice;
  final int finalPrice;
  final int? discountRate;
  final bool soldOut;
  final List<ShoppingOption> options;
  final ShoppingCategory category;
  final double rating;
  final int reviewCount;
  final List<ProductTagType> badges;

  const ShoppingModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.manufacturer,
    required this.originalPrice,
    required this.finalPrice,
    this.discountRate,
    this.soldOut = false,
    required this.options,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.badges,
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
      manufacturer: json['manufacturer'] as String,
      originalPrice: json['originalPrice'] as int,
      finalPrice: json['finalPrice'] as int,
      discountRate: json['discountRate'] as int?,
      soldOut: json['soldOut'] as bool? ?? false,
      options: (json['options'] as List<dynamic>)
          .map((e) => ShoppingOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      category: ShoppingCategory.fromString(json['category'] as String) ??
          ShoppingCategory.others,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      badges: (json['badges'] as List<dynamic>?)
              ?.map((e) => ProductTagType.values.firstWhere(
                    (type) => type.name == e.toString().toUpperCase(),
                    orElse: () => ProductTagType.newArrival,
                  ))
              .toList() ??
          [],
    );
  }

  /// Shopping -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'manufacturer': manufacturer,
      'originalPrice': originalPrice,
      'finalPrice': finalPrice,
      'discountRate': discountRate,
      'soldOut': soldOut,
      'options': options.map((e) => e.toJson()).toList(),
      'category': category.name,
      'rating': rating,
      'reviewCount': reviewCount,
      'badges': badges.map((e) => e.name).toList(),
    };
  }
}

class ShoppingOption {
  final String name;
  final int price;

  ShoppingOption({
    required this.name,
    required this.price,
  });

  factory ShoppingOption.fromJson(Map<String, dynamic> json) {
    return ShoppingOption(
      name: json['name'] as String,
      price: json['price'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
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
