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

/// 장바구니 리스트의 공통 기본 위젯
class CartListBase extends StatelessWidget {
  final List<CartItemModel> items;
  final CartCategory? selectedCategory;
  final bool useGroupHeaders; // true: 그룹별 헤더, false: 개별 카테고리별 헤더

  const CartListBase({
    super.key,
    required this.items,
    this.selectedCategory,
    this.useGroupHeaders = true,
  });

  List<CartItemModel> _getFilteredItemsByCategories(
      List<CartCategory> categories) {
    return items.where((item) => categories.contains(item.category)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context);

    if (items.isEmpty) {
      return Center(
        child: Text(
          '장바구니가 비어있어요',
          style: subtitle_M.copyWith(color: AppColors.labelAlternative),
        ),
      );
    }

    if (useGroupHeaders) {
      // 그룹별 헤더 (FullCartList용)
      return _buildGroupSections(context, cartViewModel);
    } else {
      // 개별 카테고리별 헤더 (CategoryCartList용)
      return _buildCategorySections(context, cartViewModel);
    }
  }

  /// 그룹별 섹션 구성 (숙소/체험/체험단, 쇼핑)
  Widget _buildGroupSections(
      BuildContext context, CartViewModel cartViewModel) {
    final mainCategories = [
      CartCategory.lodging,
      CartCategory.experience,
      CartCategory.experienceGroup,
    ];
    final mainItems = _getFilteredItemsByCategories(mainCategories);
    final shoppingItems = _getFilteredItemsByCategories([CartCategory.product]);

    return ListView(
      children: [
        if (mainItems.isNotEmpty)
          _buildSection(
            context: context,
            cartViewModel: cartViewModel,
            categories: mainCategories,
            items: mainItems,
            title: '숙소 / 체험 / 체험단',
          ),
        if (shoppingItems.isNotEmpty)
          _buildSection(
            context: context,
            cartViewModel: cartViewModel,
            categories: [CartCategory.product],
            items: shoppingItems,
            title: '쇼핑',
          ),
      ],
    );
  }

  /// 개별 카테고리별 섹션 구성 (숙소, 체험, 체험단, 쇼핑)
  Widget _buildCategorySections(
      BuildContext context, CartViewModel cartViewModel) {
    final sections = <Widget>[];

    // 각 카테고리별로 개별 섹션 생성
    for (final category in CartCategory.values) {
      final categoryItems =
          items.where((item) => item.category == category).toList();
      if (categoryItems.isNotEmpty) {
        sections.add(
          _buildSection(
            context: context,
            cartViewModel: cartViewModel,
            categories: [category],
            items: categoryItems,
            title: category.label,
          ),
        );
      }
    }

    return ListView(children: sections);
  }

  Widget _buildSection({
    required BuildContext context,
    required CartViewModel cartViewModel,
    required List<CartCategory> categories,
    required List<CartItemModel> items,
    String? title,
  }) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: title != null ? 16 : 0, // 헤더가 있으면 하단 패딩 추가
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.gray100,
      ),
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 헤더 (선택적)
          if (title != null) ...[
            Text(title, style: title_L),
          ],

          // 선택 바
          _buildSectionSelectBar(context, cartViewModel, categories),

          // 아이템 리스트
          ...items.map((item) => _buildCartItem(context, cartViewModel, item)),

          // 결제 버튼
          const SizedBox(height: 4),
          CTAButton(
            isEnabled: true,
            type: CTAButtonType.fillOutline,
            onPressed: () {},
            text: '결제하기',
          ),

          if (title != null) const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionSelectBar(
    BuildContext context,
    CartViewModel cartViewModel,
    List<CartCategory> categories,
  ) {
    return Container(
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
                const Text('전체 선택', style: subtitle_S),
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
  }

  Widget _buildCartItem(
    BuildContext context,
    CartViewModel cartViewModel,
    CartItemModel item,
  ) {
    return CartItemWrapper(
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
    );
  }
}
