import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/widgets/app_bar/back_button_app_bar.dart';
import 'package:myong/features/my/view_models/my_community_view_model.dart';
import 'package:provider/provider.dart';
import 'package:myong/features/community/widgets/post_item.dart';
import 'package:myong/core/utils/amplitude_logger.dart';

class MyCommunityListScreen extends StatefulWidget {
  const MyCommunityListScreen({Key? key}) : super(key: key);

  @override
  State<MyCommunityListScreen> createState() => _MyCommunityListScreenState();
}

class _MyCommunityListScreenState extends State<MyCommunityListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyCommunityViewModel>().fetchMyCommunityPosts();
    });
    AmplitudeLogger.logViewEvent(
      'app_my_community_list_screen_view',
      'app_my_community_list_screen',
    );
  }

  @override
  Widget build(BuildContext context) {
    final myCommunityVM = context.watch<MyCommunityViewModel>();

    return Scaffold(
      appBar: const BackButtonAppBar(
        title: '내가 작성한 게시글',
        type: BackButtonAppBarType.textLeft,
      ),
      body: myCommunityVM.isLoading && myCommunityVM.myPostList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : myCommunityVM.myPostList.isEmpty
              ? Center(
                  child: Text(
                    '작성한 게시글이 없어요.\n새로운 글을 작성하러 가볼까요?',
                    style: body_M.copyWith(color: AppColors.labelAssistive),
                    textAlign: TextAlign.center,
                  ),
                )
              : NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    // 스크롤 끝에 도달 시 페이징 처리
                    if (!myCommunityVM.isLoading &&
                        myCommunityVM.hasMoreData() &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      final nextPage = myCommunityVM.getNextPage();
                      if (nextPage != null) {
                        myCommunityVM.fetchMyCommunityPosts(page: nextPage);
                      }
                    }
                    return false;
                  },
                  child: ListView.builder(
                    itemCount: myCommunityVM.myPostList.length,
                    itemBuilder: (context, index) {
                      final post = myCommunityVM.myPostList[index];

                      return PostItem(
                        post: post,
                        viewName: 'my_community_list_screen',
                      );
                    },
                  ),
                ),
    );
  }
}
