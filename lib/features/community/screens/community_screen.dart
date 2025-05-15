import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/widgets/loading/circular_progress_indicator.dart';
import 'package:giftrip/features/community/models/post_model.dart';
import 'package:giftrip/features/community/widgets/post_item.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/widgets/app_bar/global_app_bar.dart';
import 'package:giftrip/core/enum/community_enum.dart';
import 'package:giftrip/features/community/view_models/community_view_model.dart';
import 'package:giftrip/features/community/widgets/community_filter_bar.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/core/utils/amplitude_logger.dart';

class CommunityScreen extends StatefulWidget {
  final PostSortType initialSort;

  const CommunityScreen({super.key, this.initialSort = PostSortType.latest});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  late PostSortType _selectedSort;
  late ScrollController _scrollController;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.initialSort;
    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 커뮤니티 화면 들어오면, 첫 페이지부터 limit=10으로 다시 불러오기
      _fetchPostsBySort(_selectedSort, limit: 10);
      // _fetchPostsBySort(_selectedSort, isRefresh: true, limit: 10);
    });
    AmplitudeLogger.logViewEvent(
        "app_community_screen_view", "app_community_screen");
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 선택된 필터에 맞는 데이터를 가져옴 (새로고침, 필터 변경 시 호출)
  Future<void> _fetchPostsBySort(PostSortType sort,
      {bool isRefresh = false, int limit = 10}) async {
    final communityVM = context.read<CommunityViewModel>();
    await communityVM.fetchPostsBySort(sort, page: 1, limit: limit); // 첫 페이지 로드
  }

  /// 당겨서 새로고침
  Future<void> _onRefresh() async {
    await _fetchPostsBySort(_selectedSort, isRefresh: true);
  }

  /// 스크롤이 리스트 끝에 도달하면 다음 페이지 데이터 요청
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _fetchNextPage();
    }
  }

  /// 다음 페이지 데이터 가져오기
  Future<void> _fetchNextPage() async {
    if (_isFetchingMore) return; // 중복 요청 방지
    _isFetchingMore = true;

    final communityVM = context.read<CommunityViewModel>();
    final nextPage = communityVM.getNextPage(_selectedSort);

    if (nextPage != null) {
      await communityVM.fetchPostsBySort(_selectedSort, page: nextPage);
    }

    _isFetchingMore = false;
  }

  /// ✅ 필터 변경
  void _onSortChanged(PostSortType newSort) {
    setState(() {
      _selectedSort = newSort;
    });
    _fetchPostsBySort(newSort);
  }

  @override
  Widget build(BuildContext context) {
    final communityVM = context.watch<CommunityViewModel>();

    List<PostModel> posts = [];
    switch (_selectedSort) {
      case PostSortType.latest:
        posts = communityVM.latestPostList;
        break;
      case PostSortType.popular:
        posts = communityVM.popularPostList;
        break;
      case PostSortType.comments:
        posts = communityVM.commentPostList;
        break;
    }

    return Scaffold(
      appBar: const GlobalAppBar(),
      body: Column(
        children: [
          // 필터 바 (고정)
          CommunityFilterBar(
            selectedSort: _selectedSort,
            onSortChanged: _onSortChanged,
          ),

          // 게시글 리스트
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.primary,
              backgroundColor: Colors.white,
              elevation: 0,
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: posts.length + (communityVM.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < posts.length) {
                      return PostItem(
                        post: posts[index],
                        viewName: "community_screen",
                      );
                    } else {
                      // 다음 페이지 가져오는 중이라면 로딩바
                      return Center(
                          child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: AppCircularProgress(),
                      ));
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
