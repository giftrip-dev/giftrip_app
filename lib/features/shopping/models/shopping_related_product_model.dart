import 'package:giftrip/features/home/models/product_model.dart';

/// 쇼핑 관련 상품 모델
class ShoppingRelatedProductModel {
  final String id;
  final String name;
  final String description;
  final String? thumbnailUrl;
  final String content;
  final String manufacturer;
  final String managerPhoneNumber;
  final int originalPrice;
  final int finalPrice;
  final bool isSoldOut;
  final bool isOptionUsed;
  final int stockCount;
  final List<dynamic> options;
  final String category;
  final double rating;
  final bool isOrderQuantityLimited;
  final int? maxOrderQuantity;
  final int reviewCount;
  final List<String> itemTags;
  final List<String> exposureTags;
  final String? relatedLink;
  final bool hasDiscount;
  final bool isAvailableToPurchase;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// 할인율 계산
  int get discountRate {
    if (originalPrice == 0) return 0;
    return ((originalPrice - finalPrice) / originalPrice * 100).round();
  }

  /// ProductModel로 변환
  ProductModel toProductModel() {
    return ProductModel(
      id: id,
      thumbnailUrl: thumbnailUrl,
      title: name,
      originalPrice: originalPrice,
      finalPrice: finalPrice,
      discountRate: discountRate,
      exposureTags: exposureTags,
      itemTags: itemTags,
      itemType: 'shopping',
      createdAt: createdAt,
      updatedAt: updatedAt,
      productType: ProductType.product,
      badges: [], // 필요한 경우 exposureTags나 itemTags 기반으로 변환 로직 추가
    );
  }

  const ShoppingRelatedProductModel({
    required this.id,
    required this.name,
    required this.description,
    this.thumbnailUrl,
    required this.content,
    required this.manufacturer,
    required this.managerPhoneNumber,
    required this.originalPrice,
    required this.finalPrice,
    required this.isSoldOut,
    required this.isOptionUsed,
    required this.stockCount,
    required this.options,
    required this.category,
    required this.rating,
    required this.isOrderQuantityLimited,
    this.maxOrderQuantity,
    required this.reviewCount,
    required this.itemTags,
    required this.exposureTags,
    this.relatedLink,
    required this.hasDiscount,
    required this.isAvailableToPurchase,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShoppingRelatedProductModel.fromJson(Map<String, dynamic> json) {
    return ShoppingRelatedProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      content: json['content'] as String,
      manufacturer: json['manufacturer'] as String,
      managerPhoneNumber: json['managerPhoneNumber'] as String,
      originalPrice: json['originalPrice'] as int,
      finalPrice: json['finalPrice'] as int,
      isSoldOut: json['isSoldOut'] as bool,
      isOptionUsed: json['isOptionUsed'] as bool,
      stockCount: json['stockCount'] as int,
      options: json['options'] as List<dynamic>,
      category: json['category'] as String,
      rating: double.parse(json['rating'] as String),
      isOrderQuantityLimited: json['isOrderQuantityLimited'] as bool,
      maxOrderQuantity: json['maxOrderQuantity'] as int?,
      reviewCount: json['reviewCount'] as int,
      itemTags:
          (json['itemTags'] as List<dynamic>).map((e) => e as String).toList(),
      exposureTags: (json['exposureTags'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      relatedLink: json['relatedLink'] as String?,
      hasDiscount: json['hasDiscount'] as bool,
      isAvailableToPurchase: json['isAvailableToPurchase'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'content': content,
      'manufacturer': manufacturer,
      'managerPhoneNumber': managerPhoneNumber,
      'originalPrice': originalPrice,
      'finalPrice': finalPrice,
      'isSoldOut': isSoldOut,
      'isOptionUsed': isOptionUsed,
      'stockCount': stockCount,
      'options': options,
      'category': category,
      'rating': rating.toStringAsFixed(2),
      'isOrderQuantityLimited': isOrderQuantityLimited,
      'maxOrderQuantity': maxOrderQuantity,
      'reviewCount': reviewCount,
      'itemTags': itemTags,
      'exposureTags': exposureTags,
      'relatedLink': relatedLink,
      'hasDiscount': hasDiscount,
      'isAvailableToPurchase': isAvailableToPurchase,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
