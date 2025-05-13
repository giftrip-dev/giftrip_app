import 'package:myong/core/utils/page_meta.dart';

/// 상품 뱃지
enum ItemBadgeType {
  newArrival, // NEW
  bestSeller, // BEST
  almostSoldOut, // 품절임박
}

/// 상품
class ProductModel {
  final String thumbnailUrl;
  final String title;
  final int originalPrice;
  final int? discountRate;
  final DateTime createdAt;

  const ProductModel({
    required this.thumbnailUrl,
    required this.title,
    required this.originalPrice,
    this.discountRate,
    required this.createdAt,
  });

  /// 할인 적용 후 최종 가격
  int get finalPrice {
    if (discountRate != null) {
      return ((originalPrice * (100 - discountRate!)) / 100).round();
    }
    return originalPrice;
  }

  /// JSON -> ProductModel
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      thumbnailUrl: json['thumbnailUrl'] as String,
      title: json['title'] as String,
      originalPrice: json['originalPrice'] as int,
      discountRate:
          json['discountRate'] != null ? json['discountRate'] as int : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Product -> JSON
  Map<String, dynamic> toJson() {
    return {
      'thumbnailUrl': thumbnailUrl,
      'title': title,
      'originalPrice': originalPrice,
      'discountRate': discountRate,
      'createdAt': createdAt.toIso8601String(),
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
