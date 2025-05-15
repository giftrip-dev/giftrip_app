import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/app_bar/search_app_bar.dart';
import 'package:giftrip/core/widgets/banner/event_banner.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/features/experience/view_models/experience_view_model.dart';
import 'package:giftrip/features/experience/widgets/persistent_category_bar.dart';
import 'package:giftrip/features/experience/widgets/experience_item_list.dart';

class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen({super.key});

  @override
  _ExperienceScreenState createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchAppBar(title: '체험'),
      body: Consumer<ExperienceViewModel>(
        builder: (context, vm, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await vm.fetchExperienceList(refresh: true);
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
                    delegate: PersistentCategoryBarDelegate(
                      selectedCategory: vm.selectedCategory,
                      onCategoryChanged: (category) {
                        vm.changeCategory(category);
                      },
                    ),
                  ),
                ];
              },
              // 3) 체험 상품 리스트
              body: vm.experienceList.isEmpty && vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ExperienceItemList(
                      experiences: vm.experienceList,
                      isLoading: vm.isLoading,
                      onLoadMore: vm.nextPage != null
                          ? () => vm.fetchExperienceList()
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
      final vm = context.read<ExperienceViewModel>();
      vm.fetchExperienceList();
    });
  }
}
