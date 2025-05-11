import 'package:flutter/material.dart';
import 'package:myong/core/utils/logger.dart';
import 'package:myong/core/utils/page_meta.dart';
import 'package:myong/features/community/models/post_model.dart';
import 'package:myong/features/community/repositories/community_repo.dart';

class MyCommunityViewModel extends ChangeNotifier {
  final CommunityRepo _communityRepo = CommunityRepo();

  // 내가 작성한 게시글 목록
  List<PostModel> _myPostList = [];
  List<PostModel> get myPostList => _myPostList;

  // 페이지네이션 관련 메타 정보
  PageMeta? _myPostMeta;

  // 로딩 상태
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// 📌 내가 작성한 게시글 리스트에서 좋아요 상태 업데이트
  void syncLikeInMyList(String postId, {required bool isLiked}) {
    final index = _myPostList.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final oldPost = _myPostList[index];
      _myPostList[index] = oldPost.copyWith(
        isLiked: isLiked,
        likeCount: isLiked ? oldPost.likeCount + 1 : oldPost.likeCount - 1,
      );
      notifyListeners();
    }
  }

  /// 📌 내가 작성한 게시글 목록 조회
  Future<void> fetchMyCommunityPosts({
    String sort = 'latest',
    int page = 1,
    int limit = 10,
  }) async {
    // 이미 페칭 중이면 중복 호출 방지
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _communityRepo.getMyCommunityList(
        sort: sort,
        page: page,
        limit: limit,
      );

      if (page == 1) {
        // 첫 페이지라면 초기화
        _myPostList = List<PostModel>.from(response.items);
        _myPostMeta = response.meta;
      } else {
        // 다음 페이지 데이터 추가
        _myPostList.addAll(response.items);
        _myPostMeta = response.meta;
      }
    } catch (e) {
      logger.d('내가 작성한 게시글 불러오기 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 📌 게시글을 모든 리스트에서 제거
  void removePostFromLists(String postId) {
    _myPostList.removeWhere((post) => post.id == postId);
    notifyListeners();
  }

  /// 다음 페이지 번호 가져오기
  int? getNextPage() {
    if (_myPostMeta == null) return null;
    if (_myPostMeta!.currentPage >= _myPostMeta!.totalPages) {
      return null;
    }
    return _myPostMeta!.currentPage + 1;
  }

  /// 더 가져올 데이터가 있는지 여부
  bool hasMoreData() {
    return getNextPage() != null;
  }
}
