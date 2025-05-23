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
  final int? quantity;
  final ProductItemType type; // 상품 타입 (일반상품, 체험상품 등)
  final DateTime? addedAt;
  final List<String> tags;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? options;
  final String? checkInTime;
  final String? checkOutTime;
  final int? standardPerson;
  final int? maxPerson;

  const CartItemModel({
    required this.id,
    required this.productId,
    required this.category,
    required this.title,
    required this.thumbnailUrl,
    required this.originalPrice,
    required this.price,
    required this.discountRate,
    this.quantity,
    required this.type,
    this.addedAt,
    required this.tags,
    this.startDate,
    this.endDate,
    this.options,
    this.checkInTime,
    this.checkOutTime,
    this.standardPerson,
    this.maxPerson,
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
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      options: json['options'] as String?,
      checkInTime: json['checkInTime'] as String?,
      checkOutTime: json['checkOutTime'] as String?,
      standardPerson: json['standardPerson'] as int?,
      maxPerson: json['maxPerson'] as int?,
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
      'addedAt': addedAt?.toIso8601String(),
      'tags': tags,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'options': options,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'standardPerson': standardPerson,
      'maxPerson': maxPerson,
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
    DateTime? startDate,
    DateTime? endDate,
    String? options,
    String? checkInTime,
    String? checkOutTime,
    int? standardPerson,
    int? maxPerson,
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
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      options: options ?? this.options,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      standardPerson: standardPerson ?? this.standardPerson,
      maxPerson: maxPerson ?? this.maxPerson,
    );
  }
}
