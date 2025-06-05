import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/shopping/models/shopping_category.dart';

/// 쇼핑 상품 모델
class ShoppingModel {
  final String id;
  final String name;
  final String description;
  final String content; // 퀼 에디터용 콘텐츠 (JSON 형태)
  final String thumbnailUrl;
  final String manufacturer;
  final String managerPhoneNumber;
  final int originalPrice;
  final int finalPrice;
  final bool isSoldOut;
  final bool isOptionUsed;
  final int? stockCount;
  final List<ShoppingOption> options;
  final ShoppingCategory category;
  final String rating;
  final int reviewCount;
  final List<String> itemTags;
  final List<String>? exposureTags;
  final String? relatedLink;
  final bool hasDiscount;
  final bool isAvailableToPurchase;
  final bool isOrderQuantityLimited;
  final int? maxOrderQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ShoppingModel({
    required this.id,
    required this.name,
    required this.description,
    required this.content,
    required this.thumbnailUrl,
    required this.manufacturer,
    required this.managerPhoneNumber,
    required this.originalPrice,
    required this.finalPrice,
    this.isSoldOut = false,
    this.isOptionUsed = false,
    this.stockCount,
    required this.options,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.itemTags,
    this.exposureTags,
    this.relatedLink,
    this.hasDiscount = false,
    this.isAvailableToPurchase = true,
    this.isOrderQuantityLimited = false,
    this.maxOrderQuantity,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 할인율 계산 (originalPrice와 finalPrice 차이로)
  int? get discountRate {
    if (!hasDiscount || originalPrice <= finalPrice) return null;
    return (((originalPrice - finalPrice) / originalPrice) * 100).round();
  }

  /// 현재 구매 가능한지 여부
  bool get soldOut => isSoldOut;

  /// 평균 평점 (rating을 double로 변환)
  double get averageRating => double.tryParse(rating) ?? 0.0;

  /// JSON -> Shopping Model
  factory ShoppingModel.fromJson(Map<String, dynamic> json) {
    return ShoppingModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      content: json['content'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      manufacturer: json['manufacturer'] as String,
      managerPhoneNumber: json['managerPhoneNumber'] as String,
      originalPrice: json['originalPrice'] as int,
      finalPrice: json['finalPrice'] as int,
      isSoldOut: json['isSoldOut'] as bool? ?? false,
      isOptionUsed: json['isOptionUsed'] as bool? ?? false,
      stockCount: json['stockCount'] as int?,
      options: (json['options'] as List<dynamic>)
          .map((e) => ShoppingOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      category: ShoppingCategory.fromString(json['category'] as String) ??
          ShoppingCategory.others,
      rating: json['rating'] as String? ?? "0.00",
      reviewCount: json['reviewCount'] as int,
      itemTags: (json['itemTags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      exposureTags: (json['exposureTags'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      relatedLink: json['relatedLink'] as String?,
      hasDiscount: json['hasDiscount'] as bool? ?? false,
      isAvailableToPurchase: json['isAvailableToPurchase'] as bool? ?? true,
      isOrderQuantityLimited: json['isOrderQuantityLimited'] as bool? ?? false,
      maxOrderQuantity: json['maxOrderQuantity'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Shopping -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'content': content,
      'thumbnailUrl': thumbnailUrl,
      'manufacturer': manufacturer,
      'managerPhoneNumber': managerPhoneNumber,
      'originalPrice': originalPrice,
      'finalPrice': finalPrice,
      'isSoldOut': isSoldOut,
      'isOptionUsed': isOptionUsed,
      'stockCount': stockCount,
      'options': options.map((e) => e.toJson()).toList(),
      'category': category.name,
      'rating': rating,
      'reviewCount': reviewCount,
      'itemTags': itemTags,
      'exposureTags': exposureTags,
      'relatedLink': relatedLink,
      'hasDiscount': hasDiscount,
      'isAvailableToPurchase': isAvailableToPurchase,
      'isOrderQuantityLimited': isOrderQuantityLimited,
      'maxOrderQuantity': maxOrderQuantity,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class ShoppingOption {
  final int seq;
  final String name;
  final int price;
  final int stockCount;

  ShoppingOption({
    required this.seq,
    required this.name,
    required this.price,
    required this.stockCount,
  });

  factory ShoppingOption.fromJson(Map<String, dynamic> json) {
    return ShoppingOption(
      seq: json['seq'] as int,
      name: json['name'] as String,
      price: json['price'] as int,
      stockCount: json['stockCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seq': seq,
      'name': name,
      'price': price,
      'stockCount': stockCount,
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
