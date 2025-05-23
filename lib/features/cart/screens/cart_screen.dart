import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/app_bar/search_app_bar.dart';
import 'package:giftrip/features/root/screens/root_screen.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/features/cart/view_models/cart_view_model.dart';
import 'package:giftrip/core/widgets/category/generic_persistent_category_bar.dart';
import 'package:giftrip/features/cart/models/cart_category.dart';
import 'package:giftrip/features/cart/widgets/all_cart_list.dart';

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
                  ),
                ),
              ];
            },
            body: AllCartList(
              items: vm.cartItems,
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
