import 'package:flutter/material.dart';
import 'package:giftrip/features/cart/models/cart_item_model.dart';
import 'package:giftrip/features/cart/models/cart_category.dart';
import 'package:giftrip/features/cart/widgets/cart_list_base.dart';

/// 카테고리별 장바구니 리스트 (섹션 헤더 없음)
class CategoryCartList extends StatelessWidget {
  final List<CartItemModel> items;
  final CartCategory? selectedCategory;

  const CategoryCartList({
    super.key,
    required this.items,
    this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return CartListBase(
      items: items,
      selectedCategory: selectedCategory,
      useGroupHeaders: false, // 개별 카테고리별 헤더 사용 (숙박, 체험, 체험단, 쇼핑)
    );
  }
}
