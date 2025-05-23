import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/features/cart/models/cart_item_model.dart';
import 'package:giftrip/features/cart/widgets/cart_item.dart';
import 'package:giftrip/features/cart/models/cart_category.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/features/cart/view_models/cart_view_model.dart';
import 'package:giftrip/core/constants/app_colors.dart';

class AllCartList extends StatelessWidget {
  final List<CartItemModel> items;
  final CartCategory? selectedCategory;
  final Function(String)? onDetailTap;

  const AllCartList({
    super.key,
    required this.items,
    this.selectedCategory,
    this.onDetailTap,
  });

  List<CartItemModel> _getFilteredItemsByCategories(
      List<CartCategory> categories) {
    return items.where((item) => categories.contains(item.category)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context);
    // 숙소/체험/체험단 그룹
    final mainCategories = [
      CartCategory.lodging,
      CartCategory.experience,
      CartCategory.experienceGroup,
    ];
    final mainItems = _getFilteredItemsByCategories(mainCategories);
    // 쇼핑 그룹
    final shoppingItems = _getFilteredItemsByCategories([CartCategory.product]);

    Widget sectionHeader(String title) => Text(
          title,
          style: title_L,
        );

    Widget sectionSelectBar(List<CartCategory> categories) => Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.line, width: 1),
            ),
            borderRadius: BorderRadius.circular(12),
            color: AppColors.gray100,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  fillColor: WidgetStateProperty.all(AppColors.white),
                  activeColor: AppColors.primaryStrong,
                  value: cartViewModel.isAllSelectedByCategories(categories),
                  onChanged: (checked) {
                    if (checked == true) {
                      cartViewModel.selectAllByCategories(categories);
                    } else {
                      cartViewModel.deselectAllByCategories(categories);
                    }
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  side: BorderSide(color: AppColors.lineNatural, width: 1),
                ),
              ),
              const SizedBox(width: 8),
              const Text('전체선택', style: subtitle_S),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  final ids = cartViewModel.cartItems
                      .where((e) =>
                          categories.contains(e.category) &&
                          cartViewModel.isItemSelected(e.id))
                      .map((e) => e.id)
                      .toList();
                  for (final id in ids) {
                    cartViewModel.removeFromCart(id);
                  }
                },
                child: const Text('선택 삭제', style: body_S),
              ),
            ],
          ),
        );

    Widget buildCartItem(CartItemModel item) => CartItem(
          item: item,
          isSelected: cartViewModel.isItemSelected(item.id),
          onSelect: () => cartViewModel.toggleSelectItem(item.id),
          onDelete: () => cartViewModel.removeFromCart(item.id),
          onQuantityChanged: (q) => cartViewModel.changeQuantity(item.id, q),
          onDetailTap: () => onDetailTap?.call(item.id),
        );

    return ListView(
      children: [
        if (mainItems.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.gray100,
            ),
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionHeader('숙박 / 체험 / 체험단'),
                sectionSelectBar(mainCategories),
                ...mainItems.map(buildCartItem),
              ],
            ),
          ),
        ],
        if (shoppingItems.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.gray100,
            ),
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionHeader('쇼핑'),
                sectionSelectBar([CartCategory.product]),
                ...shoppingItems.map(buildCartItem),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
