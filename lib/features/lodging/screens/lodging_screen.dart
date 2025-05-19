import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/app_bar/search_app_bar.dart';
import 'package:giftrip/core/widgets/banner/event_banner.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/features/lodging/view_models/lodging_view_model.dart';
import 'package:giftrip/features/lodging/widgets/persistent_category_bar.dart';
import 'package:giftrip/features/lodging/widgets/lodging_item_list.dart';

class LodgingScreen extends StatefulWidget {
  const LodgingScreen({super.key});

  @override
  _LodgingScreenState createState() => _LodgingScreenState();
}

class _LodgingScreenState extends State<LodgingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchAppBar(title: '숙박'),
      body: Consumer<LodgingViewModel>(
        builder: (context, vm, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await vm.fetchLodgingList(refresh: true);
            },
            color: AppColors.primary,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  // 1) 지역 날짜 선택 바 (고정)

                  // 여백 추가
                  // const SliverToBoxAdapter(
                  //   child: SizedBox(height: 16),
                  // ),
                  // 2) 카테고리 필터링 바 (고정)
                  SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate: PersistentCategoryBarDelegate(
                      selectedCategory: vm.selectedCategory,
                      onCategoryChanged: (category) {
                        vm.changeCategory(category);
                      },
                    ),
                  ),
                ];
              },
              // 3) 숙박 상품 리스트
              body: vm.lodgingList.isEmpty && vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : LodgingItemList(
                      lodgings: vm.lodgingList,
                      isLoading: vm.isLoading,
                      onLoadMore: vm.nextPage != null
                          ? () => vm.fetchLodgingList()
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
      final vm = context.read<LodgingViewModel>();
      vm.fetchLodgingList();
    });
  }
}
