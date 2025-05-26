import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/app_bar/search_app_bar.dart';
import 'package:giftrip/features/root/screens/root_screen.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/features/cart/view_models/cart_view_model.dart';
import 'package:giftrip/core/widgets/category/generic_persistent_category_bar.dart';
import 'package:giftrip/features/cart/models/cart_category.dart';
import 'package:giftrip/features/cart/widgets/full_cart_list.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/features/cart/widgets/category_cart_list.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final vm = context.read<CartViewModel>();
    vm.fetchCartItems(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        title: '장바구니',
        onBackPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RootScreen(selectedIndex: 0),
          ),
        ),
      ),
      body: Consumer<CartViewModel>(
        builder: (context, vm, child) {
          // 로딩 중일 때 로딩 인디케이터 표시
          if (vm.isLoading) {
            return CustomScrollView(
              physics: const NeverScrollableScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: GenericPersistentCategoryBarDelegate<CartCategory>(
                    selectedCategory: vm.selectedCategory,
                    onCategoryChanged: (category) {
                      vm.changeCategory(category);
                    },
                    categories: CartCategory.values,
                    getLabelFunc: (category) => category.label,
                    getCountFunc: (category) =>
                        vm.getItemCountByCategory(category),
                  ),
                ),
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            );
          }

          // 장바구니가 비어있을 때
          if (vm.cartItems.isEmpty) {
            return CustomScrollView(
              physics: const NeverScrollableScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: GenericPersistentCategoryBarDelegate<CartCategory>(
                    selectedCategory: vm.selectedCategory,
                    onCategoryChanged: (category) {
                      vm.changeCategory(category);
                    },
                    categories: CartCategory.values,
                    getLabelFunc: (category) => category.label,
                    getCountFunc: (category) =>
                        vm.getItemCountByCategory(category),
                  ),
                ),
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      '장바구니가 비어있어요',
                      style: subtitle_M.copyWith(
                          color: AppColors.labelAlternative),
                    ),
                  ),
                ),
              ],
            );
          }

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: GenericPersistentCategoryBarDelegate<CartCategory>(
                    selectedCategory: vm.selectedCategory,
                    onCategoryChanged: (category) {
                      vm.changeCategory(category);
                    },
                    categories: CartCategory.values,
                    getLabelFunc: (category) => category.label,
                    getCountFunc: (category) =>
                        vm.getItemCountByCategory(category),
                  ),
                ),
              ];
            },
            body: vm.selectedCategory == null
                ? FullCartList(
                    items: vm.cartItems,
                    selectedCategory: vm.selectedCategory,
                    onDetailTap: (id) {
                      // TODO: 상세보기 구현
                    },
                  )
                : CategoryCartList(
                    items: vm.cartItems
                        .where((e) => e.category == vm.selectedCategory)
                        .toList(),
                    selectedCategory: vm.selectedCategory,
                    onDetailTap: (id) {
                      // TODO: 상세보기 구현
                    },
                  ),
          );
        },
      ),
    );
  }
}
