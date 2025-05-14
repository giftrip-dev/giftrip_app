import 'package:myong/core/constants/item_type.dart';

class CartItemModel {
  final String id;
  final String productId;
  final String title;
  final String thumbnailUrl;
  final int price;
  final int quantity;
  final ProductItemType type; // 상품 타입 (일반상품, 체험상품 등)
  final DateTime addedAt;

  const CartItemModel({
    required this.id,
    required this.productId,
    required this.title,
    required this.thumbnailUrl,
    required this.price,
    required this.quantity,
    required this.type,
    required this.addedAt,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      price: json['price'] as int,
      quantity: json['quantity'] as int,
      type: ProductItemType.fromString(json['type'] as String) ??
          ProductItemType.product,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'price': price,
      'quantity': quantity,
      'type': type.value,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}
