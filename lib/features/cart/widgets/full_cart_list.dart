import 'package:flutter/material.dart';
import 'package:giftrip/features/cart/models/cart_item_model.dart';
import 'package:giftrip/features/cart/models/cart_category.dart';
import 'package:giftrip/features/cart/widgets/cart_list_base.dart';

/// 전체 장바구니 리스트 (섹션 헤더 포함)
class FullCartList extends StatelessWidget {
  final List<CartItemModel> items;
  final CartCategory? selectedCategory;

  const FullCartList({
    super.key,
    required this.items,
    this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return CartListBase(
      items: items,
      selectedCategory: selectedCategory,
      useGroupHeaders: true, // 그룹별 헤더 사용 (숙소/체험/체험단, 쇼핑)
    );
  }
}
