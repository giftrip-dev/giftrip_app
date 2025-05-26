import 'package:flutter/material.dart';
import 'package:giftrip/features/cart/models/cart_item_model.dart';
import 'package:giftrip/features/cart/models/cart_category.dart';
import 'package:giftrip/features/cart/widgets/cart_list_base.dart';

/// 전체 장바구니 리스트 (섹션 헤더 포함)
class FullCartList extends StatelessWidget {
  final List<CartItemModel> items;
  final CartCategory? selectedCategory;
  final Function(String)? onDetailTap;

  const FullCartList({
    super.key,
    required this.items,
    this.selectedCategory,
    this.onDetailTap,
  });

  @override
  Widget build(BuildContext context) {
    return CartListBase(
      items: items,
      selectedCategory: selectedCategory,
      onDetailTap: onDetailTap,
      showSectionHeaders: true, // 전체 보기에서는 섹션 헤더 표시
    );
  }
}
