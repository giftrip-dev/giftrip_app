import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/features/cart/models/cart_item_model.dart';
import 'package:giftrip/features/cart/models/cart_category.dart';
import 'package:giftrip/features/cart/widgets/cart_item_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/features/cart/view_models/cart_view_model.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/core/widgets/modal/two_button_modal.dart';

class SelectCartList extends StatelessWidget {
  final List<CartItemModel> items;
  final CartCategory? selectedCategory;
  final Function(String)? onDetailTap;

  const SelectCartList({
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

    Widget sectionSelectBar(List<CartCategory> categories) => Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.gray100,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  final isAllSelected =
                      cartViewModel.isAllSelectedByCategories(categories);
                  if (isAllSelected) {
                    cartViewModel.deselectAllByCategories(categories);
                  } else {
                    cartViewModel.selectAllByCategories(categories);
                  }
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        fillColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppColors.primaryStrong;
                          }
                          return AppColors.white;
                        }),
                        checkColor: AppColors.white,
                        activeColor: AppColors.primaryStrong,
                        value:
                            cartViewModel.isAllSelectedByCategories(categories),
                        onChanged: (checked) {
                          if (checked == true) {
                            cartViewModel.selectAllByCategories(categories);
                          } else {
                            cartViewModel.deselectAllByCategories(categories);
                          }
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        side:
                            BorderSide(color: AppColors.lineNatural, width: 1),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('전체선택', style: subtitle_S),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  final ids = cartViewModel.cartItems
                      .where((e) =>
                          categories.contains(e.category) &&
                          cartViewModel.isItemSelected(e.id))
                      .map((e) => e.id)
                      .toList();

                  if (ids.isEmpty) return; // 선택된 아이템이 없으면 리턴

                  showDialog(
                    context: context,
                    builder: (context) => TwoButtonModal(
                      title: '상품 삭제',
                      desc: '선택한 ${ids.length}개의 상품을 장바구니에서 삭제할까요?',
                      onConfirm: () {
                        Navigator.of(context).pop();
                        cartViewModel.removeMultipleFromCart(ids);
                      },
                    ),
                  );
                },
                child: const Text('선택 삭제', style: body_S),
              ),
            ],
          ),
        );

    Widget buildCartItem(CartItemModel item) => CartItemWrapper(
          item: item,
          isSelected: cartViewModel.isItemSelected(item.id),
          onSelect: () => cartViewModel.toggleSelectItem(item.id),
          onDelete: () {
            showDialog(
              context: context,
              builder: (context) => TwoButtonModal(
                title: '상품 삭제',
                desc: '장바구니에서 해당 상품을 삭제할까요?',
                onConfirm: () {
                  Navigator.of(context).pop();
                  cartViewModel.removeFromCart(item.id);
                },
              ),
            );
          },
          onQuantityChanged: (q) => cartViewModel.changeQuantity(item.id, q),
          onDetailTap: () => onDetailTap?.call(item.id),
        );

    return items.isEmpty
        ? Center(
            child: Text(
              '장바구니가 비어있어요',
              style: subtitle_M.copyWith(color: AppColors.labelAlternative),
            ),
          )
        : ListView(
            children: [
              if (mainItems.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.gray100,
                  ),
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sectionSelectBar(mainCategories),
                      ...mainItems.map(buildCartItem),
                      const SizedBox(height: 16),
                      CTAButton(
                        isEnabled: true,
                        type: CTAButtonType.fillOutline,
                        onPressed: () {},
                        text: '결제하기',
                      ),
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
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sectionSelectBar([CartCategory.product]),
                      ...shoppingItems.map(buildCartItem),
                      const SizedBox(height: 16),
                      CTAButton(
                        isEnabled: true,
                        type: CTAButtonType.fillOutline,
                        onPressed: () {},
                        text: '결제하기',
                      ),
                    ],
                  ),
                ),
              ],
            ],
          );
  }
}
