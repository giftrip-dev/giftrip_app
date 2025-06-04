import 'package:giftrip/core/utils/page_meta.dart';

/// 상품 뱃지
enum ProductTagType {
  newArrival, // NEW
  bestSeller, // BEST
  almostSoldOut, // 품절임박
  soldOut, // 품절
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
  final String id;
  final String? thumbnailUrl; // API 응답에 없을 수 있으므로 nullable
  final String title;
  final int originalPrice;
  final int finalPrice;
  final int discountRate;
  final List<String> exposureTags; // 노출 태그
  final List<String> itemTags; // 아이템 태그
  final String itemType; // 아이템 타입 (product, lodging 등)
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProductType productType; // 내부적으로 사용하는 타입
  final List<ProductTagType>? badges; // itemTags에서 변환된 배지들

  const ProductModel({
    required this.id,
    this.thumbnailUrl,
    required this.title,
    required this.originalPrice,
    required this.finalPrice,
    required this.discountRate,
    required this.exposureTags,
    required this.itemTags,
    required this.itemType,
    required this.createdAt,
    required this.updatedAt,
    required this.productType,
    this.badges,
  });

  /// 할인이 적용되었는지 여부
  bool get hasDiscount => discountRate > 0;

  /// JSON -> ProductModel
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // itemType을 ProductType으로 변환
    final itemTypeStr = json['itemType'] as String? ?? 'product';
    ProductType productType;
    switch (itemTypeStr) {
      case 'lodging':
        productType = ProductType.lodging;
        break;
      case 'experience':
        productType = ProductType.experience;
        break;
      case 'experienceGroup':
        productType = ProductType.experienceGroup;
        break;
      default:
        productType = ProductType.product;
    }

    // itemTags를 ProductTagType으로 변환
    final itemTagList =
        (json['itemTags'] as List<dynamic>?)?.cast<String>() ?? [];
    List<ProductTagType>? badges;
    if (itemTagList.isNotEmpty) {
      badges = itemTagList.map((tag) {
        switch (tag.toLowerCase()) {
          case 'new':
          case 'newArrival':
          case '신상품':
            return ProductTagType.newArrival;
          case 'best':
          case 'bestSeller':
          case '베스트':
          case '베스트셀러':
            return ProductTagType.bestSeller;
          case 'almostSoldOut':
          case '품절임박':
            return ProductTagType.almostSoldOut;
          case 'soldOut':
          case '품절':
            return ProductTagType.soldOut;
          default:
            return ProductTagType.newArrival; // 기본값
        }
      }).toList();
    }

    return ProductModel(
      id: json['id'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      title: json['title'] as String,
      originalPrice: json['originalPrice'] as int,
      finalPrice: json['finalPrice'] as int,
      discountRate: json['discountRate'] as int? ?? 0,
      exposureTags:
          (json['exposureTags'] as List<dynamic>?)?.cast<String>() ?? [],
      itemTags: itemTagList,
      itemType: itemTypeStr,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      productType: productType,
      badges: badges,
    );
  }

  /// Product -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'thumbnailUrl': thumbnailUrl,
      'title': title,
      'originalPrice': originalPrice,
      'finalPrice': finalPrice,
      'discountRate': discountRate,
      'exposureTags': exposureTags,
      'itemTags': itemTags,
      'itemType': itemType,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
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
