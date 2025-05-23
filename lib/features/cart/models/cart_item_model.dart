import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/features/cart/models/cart_category.dart';

class CartItemModel {
  final String id;
  final String productId;
  final CartCategory category;
  final String title;
  final String thumbnailUrl;
  final int originalPrice;
  final int price;
  final int? discountRate;
  final int quantity;
  final ProductItemType type; // 상품 타입 (일반상품, 체험상품 등)
  final DateTime addedAt;
  final List<String> tags;

  const CartItemModel({
    required this.id,
    required this.productId,
    required this.category,
    required this.title,
    required this.thumbnailUrl,
    required this.originalPrice,
    required this.price,
    required this.discountRate,
    required this.quantity,
    required this.type,
    required this.addedAt,
    required this.tags,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      category: CartCategory.fromString(json['category'] as String) ??
          CartCategory.product,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      originalPrice: json['originalPrice'] as int,
      price: json['price'] as int,
      discountRate: json['discountRate'] as int?,
      quantity: json['quantity'] as int,
      type: ProductItemType.fromString(json['type'] as String) ??
          ProductItemType.product,
      addedAt: DateTime.parse(json['addedAt'] as String),
      tags: json['tags'] as List<String>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'originalPrice': originalPrice,
      'price': price,
      'discountRate': discountRate,
      'quantity': quantity,
      'type': type.value,
      'addedAt': addedAt.toIso8601String(),
      'tags': tags,
    };
  }

  CartItemModel copyWith({
    String? id,
    String? productId,
    CartCategory? category,
    String? title,
    String? thumbnailUrl,
    int? originalPrice,
    int? price,
    int? discountRate,
    int? quantity,
    ProductItemType? type,
    DateTime? addedAt,
    List<String>? tags,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      category: category ?? this.category,
      title: title ?? this.title,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      originalPrice: originalPrice ?? this.originalPrice,
      price: price ?? this.price,
      discountRate: discountRate ?? this.discountRate,
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
      addedAt: addedAt ?? this.addedAt,
      tags: tags ?? this.tags,
    );
  }
}
