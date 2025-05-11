import 'package:flutter/material.dart';
import 'package:myong/core/enum/community_enum.dart';
import 'package:myong/core/widgets/banner/event_banner.dart';
import 'package:myong/features/community/view_models/community_view_model.dart';
import 'package:myong/features/home/widgets/home_app_bar.dart';
import 'package:myong/features/home/widgets/home_feature_tab.dart';
import 'package:myong/features/home/widgets/latest_post_list.dart';
import 'package:myong/features/home/widgets/popular_post_list.dart';
import 'package:provider/provider.dart';
import 'package:myong/core/constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getPostList());
  }

  Future<void> _getPostList({bool isRefresh = false}) async {
    final vm = context.read<CommunityViewModel>();
    if (vm.popularPostList.isEmpty || isRefresh) {
      await vm.fetchPostsBySort(PostSortType.popular, limit: 10);
    }
    if (vm.latestPostList.isEmpty || isRefresh) {
      await vm.fetchPostsBySort(PostSortType.latest, limit: 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Consumer<CommunityViewModel>(
        builder: (context, vm, child) {
          // 로딩 중일 땐 중앙 스피너
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 배너부터 시작하는 스크롤 영역
          return RefreshIndicator(
            onRefresh: () => _getPostList(isRefresh: true),
            color: AppColors.primary,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                // 1) 이벤트 배너
                const EventBannerWidget(),
                const SizedBox(height: 20),

                // 2) 홈 피처 탭
                const HomeFeatureTab(),
                const SizedBox(height: 30),

                // 3) 인기 글
                PopularPostListWidget(
                  posts: vm.popularPostList.take(3).toList(),
                ),
                const SizedBox(height: 20),

                // 4) 최신 글
                LatestPostListWidget(
                  posts: vm.latestPostList.take(3).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
