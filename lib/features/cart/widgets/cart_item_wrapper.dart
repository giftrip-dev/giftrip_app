import 'package:flutter/material.dart';
import 'package:giftrip/features/cart/models/cart_item_model.dart';
import 'package:giftrip/features/cart/models/cart_category.dart';
import 'package:giftrip/features/cart/widgets/cart_item_product.dart';
import 'package:giftrip/features/cart/widgets/cart_item_reservation.dart';

class CartItemWrapper extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback? onDetailTap;
  final bool isSelected;
  final VoidCallback? onSelect;
  final VoidCallback? onDelete;
  final ValueChanged<int>? onQuantityChanged;

  const CartItemWrapper({
    super.key,
    required this.item,
    this.onDetailTap,
    this.isSelected = false,
    this.onSelect,
    this.onDelete,
    this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    switch (item.category) {
      case CartCategory.lodging:
      case CartCategory.experience:
      case CartCategory.experienceGroup:
        return CartItemReservation(
          item: item,
          onDetailTap: onDetailTap,
          isSelected: isSelected,
          onSelect: onSelect,
          onDelete: onDelete,
          onQuantityChanged: onQuantityChanged,
        );
      case CartCategory.product:
        return CartItemProduct(
          item: item,
          onDetailTap: onDetailTap,
          isSelected: isSelected,
          onSelect: onSelect,
          onDelete: onDelete,
          onQuantityChanged: onQuantityChanged,
        );
    }
  }
}
