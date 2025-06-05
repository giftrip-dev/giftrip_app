import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/app_bar/search_app_bar.dart';
import 'package:giftrip/core/widgets/banner/event_banner.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/features/lodging/view_models/lodging_view_model.dart';
import 'package:giftrip/features/lodging/widgets/lodging_item_list.dart';
import 'package:giftrip/features/lodging/widgets/lodging_filter_combined_bar.dart';
import 'package:giftrip/features/lodging/screens/location_screen.dart';
import 'package:giftrip/features/lodging/widgets/stay_option_bottom_sheet.dart';
import 'package:giftrip/features/lodging/widgets/lodging_category_bar.dart';
import 'package:giftrip/features/root/screens/root_screen.dart';

class LodgingScreen extends StatefulWidget {
  const LodgingScreen({super.key});

  @override
  _LodgingScreenState createState() => _LodgingScreenState();
}

class _LodgingScreenState extends State<LodgingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        title: '숙소',
        onBackPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const RootScreen(selectedIndex: 0)),
          );
        },
      ),
      body: Consumer<LodgingViewModel>(
        builder: (context, vm, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await vm.fetchLodgingList(refresh: true);
            },
            color: AppColors.primary,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: vm.lodgingList.isEmpty && !vm.isLoading
                ? Column(
                    children: [
                      // 1) 이벤트 배너 추가
                      const EventBannerWidget(),
                      const SizedBox(height: 16),
                      // 2) 지역 날짜 선택 바 (고정)
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 16),
                              child: LodgingFilterCombinedBar(
                                locationText: vm.subLocation,
                                onLocationTap: () async {
                                  final selected = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LocationScreen(
                                        currentLocation: vm.subLocation,
                                      ),
                                    ),
                                  );
                                  if (selected is String &&
                                      selected.isNotEmpty) {
                                    vm.setLocationText(selected);
                                  }
                                },
                                stayOptionText: vm.stayOptionText,
                                onStayOptionTap: () {
                                  StayOptionBottomSheet.show(context);
                                },
                              ),
                            ),
                            LodgingCategoryBar(
                              selectedCategory: vm.selectedCategory,
                              onCategoryChanged: (category) {
                                vm.changeCategory(category);
                              },
                            ),
                          ],
                        ),
                      ),
                      // 3) 빈 상태 메시지
                      Expanded(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.only(
                              bottom: 100,
                            ),
                            child: Text(
                              '예약 가능한 숙소가 존재하지 않습니다',
                              style: subtitle_M.copyWith(
                                color: AppColors.labelAlternative,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : NestedScrollView(
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
                        // 2) 지역 날짜 선택 바 (고정)
                        SliverPersistentHeader(
                          pinned: true,
                          floating: true,
                          delegate: LodgingFilterCombinedBarDelegate(
                            selectedCategory: vm.selectedCategory,
                            onCategoryChanged: (category) {
                              vm.changeCategory(category);
                            },
                            locationText: vm.subLocation,
                            stayOptionText: vm.stayOptionText,
                            onLocationTap: () async {
                              final selected = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LocationScreen(
                                    currentLocation: vm.subLocation,
                                  ),
                                ),
                              );
                              if (selected is String && selected.isNotEmpty) {
                                vm.setLocationText(selected);
                              }
                            },
                            onStayOptionTap: () {
                              StayOptionBottomSheet.show(context);
                            },
                          ),
                        ),
                      ];
                    },
                    // 3) 숙소 상품 리스트
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
