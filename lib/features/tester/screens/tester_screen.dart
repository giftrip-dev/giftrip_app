import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/app_bar/search_app_bar.dart';
import 'package:giftrip/core/widgets/banner/event_banner.dart';
import 'package:giftrip/core/widgets/category/generic_persistent_category_bar.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/features/tester/models/tester_category.dart';
import 'package:giftrip/features/tester/view_models/tester_view_model.dart';
import 'package:giftrip/features/tester/widgets/tester_item_list.dart';

class TesterScreen extends StatefulWidget {
  const TesterScreen({super.key});

  @override
  _TesterScreenState createState() => _TesterScreenState();
}

class _TesterScreenState extends State<TesterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchAppBar(title: '체험단'),
      body: Consumer<TesterViewModel>(
        builder: (context, vm, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await vm.fetchTesterList(refresh: true);
            },
            color: AppColors.primary,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  // 1) 이벤트 배너
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
                        GenericPersistentCategoryBarDelegate<TesterCategory>(
                      selectedCategory: vm.selectedCategory,
                      onCategoryChanged: (category) {
                        vm.changeCategory(category);
                      },
                      categories: TesterCategory.values,
                      getLabelFunc: (category) => category.label,
                    ),
                  ),
                  // 카테고리 바와 리스트 사이 여백 추가
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 16),
                  ),
                ];
              },
              // 3) 체험 상품 리스트
              body: vm.testerList.isEmpty && vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TesterItemList(
                      testers: vm.testerList,
                      isLoading: vm.isLoading,
                      onLoadMore: vm.nextPage != null
                          ? () => vm.fetchTesterList()
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
      final vm = context.read<TesterViewModel>();
      vm.fetchTesterList();
    });
  }
}
