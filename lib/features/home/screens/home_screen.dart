import 'package:flutter/material.dart';
import 'package:myong/core/enum/community_enum.dart';
import 'package:myong/core/widgets/app_bar/global_app_bar.dart';
import 'package:myong/features/community/view_models/community_view_model.dart';
import 'package:myong/features/home/widgets/banner.dart';
import 'package:myong/features/home/widgets/latest_post_list.dart';
import 'package:myong/features/home/widgets/popular_post_list.dart';
import 'package:provider/provider.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/utils/amplitude_logger.dart';

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
    AmplitudeLogger.logViewEvent("app_home_screen_view", "app_home_screen");
  }

  // 기존 데이터가 없을 때만 요청 (중복 요청 방지)
  Future<void> _getPostList({isRefresh}) async {
    final communityVM = context.read<CommunityViewModel>();

    if (communityVM.popularPostList.isEmpty || isRefresh == true) {
      await communityVM.fetchPostsBySort(PostSortType.popular, limit: 10);
    }
    if (communityVM.latestPostList.isEmpty || isRefresh == true) {
      await communityVM.fetchPostsBySort(PostSortType.latest, limit: 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppBar(),
      body: Container(
        color: AppColors.backgroundAlternative,
        child: Consumer<CommunityViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return RefreshIndicator(
              onRefresh: () => _getPostList(isRefresh: true),
              color: AppColors.primary,
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                    top: 8, left: 16, right: 16, bottom: 30),
                children: [
                  const BannerWidget(
                      assetImagePath: 'assets/images/illustrator/banner.png'),
                  const SizedBox(height: 20),

                  // 인기글 위젯
                  PopularPostListWidget(
                      posts: viewModel.popularPostList.take(3).toList()),
                  const SizedBox(height: 20),

                  // 최신 글 위젯
                  LatestPostListWidget(
                      posts: viewModel.latestPostList.take(3).toList()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
