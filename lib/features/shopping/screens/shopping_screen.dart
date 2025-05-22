import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/app_bar/search_app_bar.dart';
import 'package:giftrip/core/widgets/banner/event_banner.dart';
import 'package:giftrip/core/widgets/category/generic_persistent_category_bar.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/features/shopping/models/shopping_category.dart';
import 'package:giftrip/features/shopping/view_models/shopping_view_model.dart';
import 'package:giftrip/features/shopping/widgets/shopping_item_list.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchAppBar(title: '쇼핑'),
      body: Consumer<ShoppingViewModel>(
        builder: (context, vm, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await vm.fetchShoppingList(refresh: true);
            },
            color: AppColors.primary,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  // 1) 이벤트 배너 (스크롤됨)
                  const SliverToBoxAdapter(
                    child: EventBannerWidget(),
                  ),
                  // 여백 추가
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 16),
                  ),
                  // 2) 카테고리 필터링 바 (고정)
                  SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate:
                        GenericPersistentCategoryBarDelegate<ShoppingCategory>(
                      selectedCategory: vm.selectedCategory,
                      onCategoryChanged: (category) {
                        vm.changeCategory(category);
                      },
                      categories: ShoppingCategory.values,
                      getLabelFunc: (category) => category.label,
                    ),
                  ),
                  // 카테고리 바와 리스트 사이 여백 추가
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 16),
                  ),
                ];
              },
              // 3) 쇼핑 상품 리스트
              body: vm.shoppingList.isEmpty && vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ShoppingItemList(
                      shoppingItems: vm.shoppingList,
                      isLoading: vm.isLoading,
                      onLoadMore: vm.nextPage != null
                          ? () => vm.fetchShoppingList()
                          : null,
                    ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // 초기 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<ShoppingViewModel>();
      vm.fetchShoppingList();
    });
  }
}
