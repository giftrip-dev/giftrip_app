import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/loading/circular_progress_indicator.dart';
import 'package:giftrip/features/community/models/post_model.dart';
import 'package:giftrip/features/community/widgets/post_item.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/widgets/app_bar/global_app_bar.dart';
import 'package:giftrip/core/enum/community_enum.dart';
import 'package:giftrip/features/community/view_models/community_view_model.dart';
import 'package:giftrip/features/community/widgets/community_filter_bar.dart';
import 'package:giftrip/features/community/widgets/search/custom_search_bar.dart';
import 'package:giftrip/core/services/storage_service.dart';
import 'package:giftrip/core/utils/amplitude_logger.dart';

class SearchScreen extends StatefulWidget {
  final PostSortType initialSort;

  const SearchScreen({super.key, this.initialSort = PostSortType.latest});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late PostSortType _selectedSort = widget.initialSort;
  late final ScrollController _scrollController = ScrollController()
    ..addListener(_onScroll);
  bool _isFetchingMore = false;
  String _searchQuery = '';
  final GlobalStorage _storage = GlobalStorage();
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches(); // 최근 검색어 로드
    AmplitudeLogger.logViewEvent("app_search_screen_view", "app_search_screen");
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 선택된 필터에 맞는 데이터를 가져옴 (새로고침, 필터 변경 시 호출)
  Future<void> _fetchPostsBySort(String searchQuery, PostSortType sort,
      {bool isRefresh = false, int limit = 10}) async {
    final communityVM = context.read<CommunityViewModel>();
    await communityVM.fetchSearchPosts(searchQuery, sort,
        page: 1, limit: limit); // 첫 페이지 로드
  }

  /// 당겨서 새로고침
  Future<void> _onRefresh() async {
    await _fetchPostsBySort(_searchQuery, _selectedSort, isRefresh: true);
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
    setState(() {
      _isFetchingMore = true;
    });

    final communityVM = context.read<CommunityViewModel>();
    final nextPage = communityVM.getNextPage(_selectedSort);

    // 현재 스크롤 위치 저장
    final double currentScrollPosition = _scrollController.position.pixels;

    if (nextPage != null) {
      try {
        // 다음 페이지 데이터 요청
        await communityVM.fetchSearchPosts(_searchQuery, _selectedSort,
            page: nextPage);

        // 데이터 로드 후 스크롤 위치 복원
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(currentScrollPosition);
          }
        });
      } finally {
        // 마지막에 로딩 상태 해제
        setState(() {
          _isFetchingMore = false;
        });
      }
    } else {
      setState(() {
        _isFetchingMore = false;
      });
    }
  }

  /// ✅ 필터 변경
  void _onSortChanged(PostSortType newSort) {
    setState(() {
      _selectedSort = newSort;
    });
    _fetchPostsBySort(_searchQuery, newSort);

    // 필터 변경 시 스크롤을 맨 위로 이동
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    AmplitudeLogger.logClickEvent(
      'community_filter_click',
      '${newSort}_button',
      'search_screen',
    );
  }

  Future<void> _loadRecentSearches() async {
    final recentSearches = await _storage.getRecentSearch();
    setState(() {
      _recentSearches = recentSearches ?? [];
    });
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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 키보드 숨기기
      },
      child: Scaffold(
        appBar: const GlobalAppBar(),
        body: Column(
          children: [
            CustomSearchBar(
              controller: TextEditingController(text: _searchQuery),
              recentSearches: _recentSearches,
              onSearch: (query) {
                setState(() {
                  _searchQuery = query;
                });
                _fetchPostsBySort(_searchQuery, _selectedSort); // 검색 시 fetch 호출
                AmplitudeLogger.logViewEvent(
                  'app_search_post',
                  'app_search_screen',
                );
              },
              onRemoveSearch: (query) {
                setState(() {
                  _searchQuery = '';
                });
              },
              onClearSearch: () {
                setState(() {
                  _searchQuery = ''; // 검색어 지울 때 _searchQuery를 빈 문자열로 설정
                });
              },
            ),
            if (_searchQuery.isNotEmpty) ...[
              CommunityFilterBar(
                selectedSort: _selectedSort,
                onSortChanged: _onSortChanged,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: AppColors.primary,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  child: communityVM.isLoading &&
                          _searchQuery.isNotEmpty &&
                          posts.isEmpty
                      ? const Center(
                          child:
                              AppCircularProgress()) // ⬅️ 로딩 중이고 데이터가 없을 때만 중앙에 로딩 표시
                      : posts.isNotEmpty
                          ? ListView.builder(
                              controller: _scrollController,
                              itemCount: posts.length +
                                  (communityVM.isLoading || _isFetchingMore
                                      ? 1
                                      : 0),
                              itemBuilder: (context, index) {
                                if (index < posts.length) {
                                  return PostItem(
                                    post: posts[index],
                                    viewName: "search_screen",
                                  );
                                } else {
                                  // 마지막 아이템에 로딩 인디케이터 표시
                                  return Center(
                                      child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: AppCircularProgress(),
                                  ));
                                }
                              },
                            )
                          : Center(
                              child: Text(
                                '검색 결과가 없습니다.',
                                style: subtitle_L.copyWith(
                                  color: AppColors.labelAssistive,
                                ),
                              ),
                            ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
