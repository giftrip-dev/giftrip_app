import 'package:giftrip/core/utils/page_meta.dart';

/// 상품 뱃지
enum ProductTagType {
  newArrival, // NEW
  bestSeller, // BEST
  almostSoldOut, // 품절임박
}

/// 상품 타입
enum ProductType {
  product, // 식품/가구/의류 등
  lodging, // 숙소
  experience, // 체험
  experienceGroup, // 체험단
}

/// 상품
class ProductModel {
  final String thumbnailUrl;
  final String title;
  final int originalPrice;
  final int finalPrice;
  final int? discountRate;
  final DateTime createdAt;
  final ProductType productType;
  final List<ProductTagType>? badges;

  const ProductModel({
    required this.thumbnailUrl,
    required this.title,
    required this.originalPrice,
    required this.finalPrice,
    this.discountRate,
    required this.createdAt,
    required this.productType,
    this.badges,
  });

  /// 할인이 적용되었는지 여부
  bool get hasDiscount => discountRate != null && discountRate! > 0;

  /// JSON -> ProductModel
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // 상품 타입 변환
    final productTypeStr = json['productType'] as String;
    final productType = ProductType.values.firstWhere(
      (type) => type.toString().split('.').last == productTypeStr,
      orElse: () => ProductType.product,
    );

    // 배지 타입 변환
    List<ProductTagType>? badges;
    if (json['badges'] != null) {
      final List<dynamic> badgeList = json['badges'] as List<dynamic>;
      badges = badgeList.map((badgeStr) {
        return ProductTagType.values.firstWhere(
          (badge) => badge.toString().split('.').last == badgeStr,
          orElse: () => ProductTagType.newArrival,
        );
      }).toList();
    }

    return ProductModel(
      thumbnailUrl: json['thumbnailUrl'] as String,
      title: json['title'] as String,
      originalPrice: json['originalPrice'] as int,
      finalPrice: json['finalPrice'] as int,
      discountRate:
          json['discountRate'] != null ? json['discountRate'] as int : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      productType: productType,
      badges: badges,
    );
  }

  /// Product -> JSON
  Map<String, dynamic> toJson() {
    return {
      'thumbnailUrl': thumbnailUrl,
      'title': title,
      'originalPrice': originalPrice,
      'finalPrice': finalPrice,
      'discountRate': discountRate,
      'createdAt': createdAt.toIso8601String(),
      'productType': productType.toString().split('.').last,
      'badges':
          badges?.map((badge) => badge.toString().split('.').last).toList(),
    };
  }
}

/// 페이징 응답
class ProductPageResponse {
  final List<ProductModel> items;
  final PageMeta meta;

  ProductPageResponse({
    required this.items,
    required this.meta,
  });

  factory ProductPageResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>;
    return ProductPageResponse(
      items: itemsJson.map((e) => ProductModel.fromJson(e)).toList(),
      meta: PageMeta.fromJson(json['meta']),
    );
  }
}
