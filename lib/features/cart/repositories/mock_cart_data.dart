import 'package:giftrip/features/cart/models/cart_item_model.dart';
import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/features/cart/models/cart_category.dart';
import 'dart:math';
import 'package:intl/intl.dart';

final random = Random();

/// 목업 장바구니 데이터 생성 함수
List<CartItemModel> generateMockCartList() {
  final now = DateTime.now();
  final dateFormat = DateFormat('yyyy.MM.dd (E)', 'ko_KR');

  return [
    // 숙박 2개
    // for (int i = 0; i < 2; i++)
    //   CartItemModel(
    //     id: 'cart_lodging_${i + 1}',
    //     productId: 'prod_lodging_${i + 1}',
    //     category: CartCategory.lodging,
    //     title: '숙박 ${i + 1}',
    //     thumbnailUrl: 'assets/png/banner.png',
    //     originalPrice: 100000 + i * 10000,
    //     price: 90000 + i * 10000,
    //     discountRate: 10,
    //     type: ProductItemType.lodging,
    //     quantity: 1,
    //     addedAt: now.subtract(Duration(days: i + 1)),
    //     tags: [],
    //   ),
    // // 체험 2개
    // for (int i = 0; i < 2; i++)
    //   CartItemModel(
    //     id: 'cart_experience_${i + 1}',
    //     productId: 'prod_experience_${i + 1}',
    //     category: CartCategory.experience,
    //     title: '체험 상품 ${i + 1}',
    //     thumbnailUrl: 'assets/png/banner.png',
    //     originalPrice: 50000 + i * 5000,
    //     price: 45000 + i * 5000,
    //     discountRate: 10,
    //     type: ProductItemType.experience,
    //     quantity: 1,
    //     addedAt: now.subtract(Duration(days: i + 2)),
    //     tags: ['특가상품'],
    //   ),
    // // 상품 3개
    // for (int i = 0; i < 3; i++)
    //   CartItemModel(
    //     id: 'cart_product_${i + 1}',
    //     productId: 'prod_product_${i + 1}',
    //     category: CartCategory.product,
    //     title: '상품 ${i + 1}',
    //     thumbnailUrl: 'assets/png/banner.png',
    //     originalPrice: 30000 + i * 3000,
    //     price: 27000 + i * 3000,
    //     discountRate: 10,
    //     type: ProductItemType.product,
    //     quantity: 1,
    //     addedAt: now.subtract(Duration(days: i + 3)),
    //     tags: [],
    //   ),
    // // 체험단 1개
    // CartItemModel(
    //   id: 'cart_exgroup_1',
    //   productId: 'prod_exgroup_1',
    //   category: CartCategory.experienceGroup,
    //   title: '체험단 상품 1',
    //   thumbnailUrl: 'assets/png/banner.png',
    //   originalPrice: 80000,
    //   price: 72000,
    //   discountRate: 10,
    //   type: ProductItemType.experienceGroup,
    //   quantity: 1,
    //   addedAt: now.subtract(const Duration(days: 4)),
    //   tags: [],
    // ),
  ];
}
