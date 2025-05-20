import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/app_bar/search_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/features/lodging/view_models/lodging_view_model.dart';
import 'package:giftrip/features/lodging/widgets/lodging_item_list.dart';
import 'package:giftrip/features/lodging/widgets/lodging_filter_combined_bar.dart';
import 'package:giftrip/features/lodging/screens/location_screen.dart';

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
                  SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate: LodgingFilterCombinedBarDelegate(
                      selectedCategory: vm.selectedCategory,
                      onCategoryChanged: (category) {
                        vm.changeCategory(category);
                      },
                      locationText: vm.locationText,
                      datePeopleText: '',
                      onLocationTap: () async {
                        final selected = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LocationScreen(),
                          ),
                        );
                        if (selected is String && selected.isNotEmpty) {
                          vm.setLocationText(selected);
                        }
                      },
                      onDatePeopleTap: () {
                        // TODO: 날짜/인원 선택 모달 등 연결
                      },
                    ),
                  ),
                  // // 2) 카테고리 필터링 바 (고정)
                  // SliverPersistentHeader(
                  //   pinned: true,
                  //   floating: true,
                  //   delegate: PersistentCategoryBarDelegate(
                  //     selectedCategory: vm.selectedCategory,
                  //     onCategoryChanged: (category) {
                  //       vm.changeCategory(category);
                  //     },
                  //   ),
                  // ),
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
