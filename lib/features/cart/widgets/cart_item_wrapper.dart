import 'package:flutter/material.dart';
import 'package:giftrip/features/cart/models/cart_item_model.dart';
import 'package:giftrip/features/cart/models/cart_category.dart';
import 'package:giftrip/features/cart/widgets/cart_item_product.dart';
import 'package:giftrip/features/cart/widgets/cart_item_reservation.dart';
import 'package:giftrip/features/experience/screens/experience_detail_screen.dart';
import 'package:giftrip/features/lodging/screens/lodging_detail_screen.dart';
import 'package:giftrip/features/shopping/screens/shopping_detail_screen.dart';
import 'package:giftrip/features/tester/screens/tester_detail_screen.dart';

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

  /// 상품명 클릭 시 상세 페이지로 이동하는 핸들러
  void _navigateToDetail(BuildContext context) {
    switch (item.category) {
      case CartCategory.lodging:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LodgingDetailScreen(
              lodgingId: item.id,
            ),
          ),
        );
        break;
      case CartCategory.experience:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExperienceDetailScreen(
              experienceId: item.id,
            ),
          ),
        );
        break;
      case CartCategory.experienceGroup:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TesterDetailScreen(
              testerId: item.id,
            ),
          ),
        );
        break;
      case CartCategory.product:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShoppingDetailScreen(
              shoppingId: item.id,
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (item.category) {
      case CartCategory.lodging:
      case CartCategory.experience:
      case CartCategory.experienceGroup:
        return CartItemReservation(
          item: item,
          onDetailTap: onDetailTap,
          onTitleTap: () => _navigateToDetail(context),
          isSelected: isSelected,
          onSelect: onSelect,
          onDelete: onDelete,
          onQuantityChanged: onQuantityChanged,
        );
      case CartCategory.product:
        return CartItemProduct(
          item: item,
          onDetailTap: onDetailTap,
          onTitleTap: () => _navigateToDetail(context),
          isSelected: isSelected,
          onSelect: onSelect,
          onDelete: onDelete,
          onQuantityChanged: onQuantityChanged,
        );
    }
  }
}
