import 'package:flutter/material.dart';
import 'package:myong/core/enum/community_enum.dart';
import 'package:myong/core/utils/logger.dart';
import 'package:myong/core/utils/page_meta.dart';
import 'package:myong/features/community/models/post_model.dart';
import 'package:myong/features/community/repositories/community_repo.dart';
import 'package:myong/features/community/view_models/comment_view_model.dart';
import 'package:myong/features/my/view_models/my_community_view_model.dart';
import 'package:provider/provider.dart';

class CommunitySearchViewModel extends ChangeNotifier {
  final CommunityRepo _communityRepo = CommunityRepo();

  // 상태
  List<PostModel> _latestPostList = []; // 최신순
  List<PostModel> _popularPostList = []; // 인기순
  List<PostModel> _commentPostList = []; // 댓글 많은 순
  PostModel? _selectedPost; // 상세 게시글
  PageMeta? _latestMeta;
  PageMeta? _popularMeta;
  PageMeta? _commentMeta;
  bool _isLoading = false; // 게시글 리스트 로딩 여부
  bool _isDetailLoading = false; // 상세 로딩 여부

  // Getter
  List<PostModel> get latestPostList => _latestPostList;
  List<PostModel> get popularPostList => _popularPostList;
  List<PostModel> get commentPostList => _commentPostList;
  PostModel? get selectedPost => _selectedPost;
  bool get isLoading => _isLoading;
  bool get isDetailLoading => _isDetailLoading;

  // 다음 페이지 가져오기
  int? getNextPage(PostSortType sort) {
    final meta = (sort == PostSortType.latest)
        ? _latestMeta
        : (sort == PostSortType.popular)
            ? _popularMeta
            : _commentMeta; //

    if (meta == null || meta.currentPage >= meta.totalPages) return null;
    return meta.currentPage + 1;
  }

  // 추가 데이터 여부
  bool hasMoreData(PostSortType sort) {
    return getNextPage(sort) != null;
  }

  /// 내부 유틸 메서드: 전달받은 postData로 기존 목록 내 동일 ID 게시글 업데이트
  void _updatePostItemInList(PostModel updatedPost) {
    void updateList(List<PostModel> list) {
      final idx = list.indexWhere((p) => p.id == updatedPost.id);

      if (idx != -1) {
        final existingPost = list[idx];

        // 기존 데이터에 이미지 파일이 존재하면 썸네일로 업데이트
        final mergedPost = updatedPost.copyWith(
          thumbnailUrl: existingPost.fileUrls.isNotEmpty
              ? existingPost.fileUrls[0]
              : null,
        );

        list[idx] = mergedPost;
      }
    }

    updateList(_latestPostList);
    updateList(_popularPostList);
    updateList(_commentPostList);
  }

  /// 📌 상세 게시글 조회
  Future<void> fetchPostDetail(String postId) async {
    _isDetailLoading = true;
    notifyListeners();
    try {
      final postDetail = await _communityRepo.getPostDetail(postId: postId);
      _selectedPost = postDetail;

      // 로컬 목록 데이터에도 반영(이미 가져온 목록에 해당 게시글이 있다면 덮어씀)
      _updatePostItemInList(postDetail);
    } catch (e) {
      logger.e('상세 조회 실패: ${e.toString()}');
    } finally {
      _isDetailLoading = false;
      notifyListeners();
    }
  }

  /// 📌 기존 목록에서 특정 게시글의 댓글 개수 업데이트
  void updateCommentCount(BuildContext context, String postId) {
    void updateList(List<PostModel> list, int newCount) {
      final index = list.indexWhere((post) => post.id == postId);
      if (index != -1) {
        list[index] = list[index].copyWith(commentCount: newCount);
      }
    }

    // 전체 댓글 개수 계산 (오리지널 댓글 + 답글 포함)
    final totalCommentCount =
        context.read<CommentViewModel>().getTotalCommentCount(postId);

    updateList(_latestPostList, totalCommentCount);
    updateList(_popularPostList, totalCommentCount);
    updateList(_commentPostList, totalCommentCount);

    if (_selectedPost?.id == postId) {
      _selectedPost = _selectedPost!.copyWith(commentCount: totalCommentCount);
    }

    notifyListeners();
  }

  /// 📌 좋아요 토글
  Future<void> toggleLike(
      BuildContext context, String postId, bool isLiked) async {
    try {
      bool success;
      if (isLiked) {
        success = await _communityRepo.deleteLike(postId: postId);
      } else {
        success = await _communityRepo.postLike(postId: postId);
      }

      if (success) {
        // 서버 성공 시 로컬에서도 업데이트
        if (_selectedPost != null && _selectedPost!.id == postId) {
          final updatedPost = _selectedPost!.copyWith(
            isLiked: !isLiked,
            likeCount: !isLiked
                ? _selectedPost!.likeCount + 1
                : _selectedPost!.likeCount - 1,
          );
          _selectedPost = updatedPost;
        }

        // 기존 목록에서 좋아요 상태 동기화
        _syncLikeInAllLists(postId, isLiked: !isLiked);

        // 내가 작성한 게시글 리스트(MyCommunityViewModel)도 업데이트
        final myCommunityVM = context.read<MyCommunityViewModel>();
        myCommunityVM.syncLikeInMyList(postId, isLiked: !isLiked);
      }
    } catch (e) {
      logger.d('좋아요 토글 실패: $e');
    }
    notifyListeners();
  }

  /// 📌 전체 리스트에 대해서 좋아요/좋아요 취소 동기화
  void _syncLikeInAllLists(String postId, {required bool isLiked}) {
    void updateList(List<PostModel> list) {
      final index = list.indexWhere((post) => post.id == postId);
      if (index != -1) {
        final oldPost = list[index];
        list[index] = oldPost.copyWith(
          isLiked: isLiked,
          likeCount: isLiked ? oldPost.likeCount + 1 : oldPost.likeCount - 1,
        );
      }
    }

    updateList(_latestPostList);
    updateList(_popularPostList);
    updateList(_commentPostList);
  }

  /// 📌 커뮤니티 게시글 조회
  Future<void> fetchPostsBySort(PostSortType sort,
      {int page = 1, int limit = 10}) async {
    _isLoading = true;
    notifyListeners();

    // 로딩바를 위한 딜레이
    if (page == 1) {
      await Future.delayed(Duration(milliseconds: 100));
    } else {
      await Future.delayed(Duration(milliseconds: 400));
    }

    try {
      final response = await _communityRepo.getCommunityList(
        sort: sort.toUpperString(),
        page: page,
        limit: limit,
      );

      if (page == 1) {
        // 첫 페이지면 기존 데이터 초기화
        if (sort == PostSortType.latest) {
          _latestPostList = List<PostModel>.from(response.items);
          _latestMeta = response.meta;
        } else if (sort == PostSortType.popular) {
          _popularPostList = List<PostModel>.from(response.items);
          _popularMeta = response.meta;
        } else if (sort == PostSortType.comments) {
          _commentPostList = List<PostModel>.from(response.items);
          _commentMeta = response.meta;
        }
      } else {
        // 다음 페이지 데이터 추가
        if (sort == PostSortType.latest) {
          _latestPostList.addAll(response.items);
          _latestMeta = response.meta;
        } else if (sort == PostSortType.popular) {
          _popularPostList.addAll(response.items);
          _popularMeta = response.meta;
        } else if (sort == PostSortType.comments) {
          _commentPostList.addAll(response.items);
          _commentMeta = response.meta;
        }
      }
    } catch (e) {
      logger.e('게시글 불러오기 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 📌 커뮤니티 게시글 삭제
  Future<bool> deletePost(BuildContext context, String postId) async {
    try {
      final success = await _communityRepo.deletePost(postId: postId);

      if (success) {
        // 삭제 성공 시 리스트에서 해당 게시글 제거
        _removePostFromLists(postId);

        // 선택된 게시글이 삭제된 게시글이라면 초기화
        if (_selectedPost?.id == postId) {
          _selectedPost = null;
        }

        // 내가 작성한 게시글 리스트(MyCommunityViewModel)에서도 삭제
        final myCommunityVM = context.read<MyCommunityViewModel>();
        myCommunityVM.removePostFromLists(postId);
        return true;
      }
      return false;
    } catch (e) {
      logger.e('게시글 삭제 실패: $e');
      return false;
    } finally {
      notifyListeners();
    }
  }

  /// 📌 특정 게시글을 모든 리스트에서 제거
  void _removePostFromLists(String postId) {
    _latestPostList.removeWhere((post) => post.id == postId);
    _popularPostList.removeWhere((post) => post.id == postId);
    _commentPostList.removeWhere((post) => post.id == postId);
  }

  Future<void> fetchSearchPosts(String keyword, PostSortType sort,
      {int page = 1, int limit = 10}) async {
    _isLoading = true;
    notifyListeners();

    // 로딩바를 위한 딜레이
    if (page == 1) {
      await Future.delayed(Duration(milliseconds: 100));
    } else {
      await Future.delayed(Duration(milliseconds: 400));
    }

    try {
      final response = await _communityRepo.getSearchCommunityList(
        keyword: keyword,
        sort: sort.toUpperString(),
        page: page,
        limit: limit,
      );

      if (page == 1) {
        // 첫 페이지면 기존 데이터 초기화
        if (sort == PostSortType.latest) {
          _latestPostList = List<PostModel>.from(response.items);
          _latestMeta = response.meta;
        } else if (sort == PostSortType.popular) {
          _popularPostList = List<PostModel>.from(response.items);
          _popularMeta = response.meta;
        } else if (sort == PostSortType.comments) {
          _commentPostList = List<PostModel>.from(response.items);
          _commentMeta = response.meta;
        }
      } else {
        // 다음 페이지 데이터 추가
        if (sort == PostSortType.latest) {
          _latestPostList.addAll(response.items);
          _latestMeta = response.meta;
        } else if (sort == PostSortType.popular) {
          _popularPostList.addAll(response.items);
          _popularMeta = response.meta;
        } else if (sort == PostSortType.comments) {
          _commentPostList.addAll(response.items);
          _commentMeta = response.meta;
        }
      }
    } catch (e) {
      logger.e('게시글 불러오기 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearPostLists() {
    _latestPostList.clear();
    _popularPostList.clear();
    _commentPostList.clear();
    notifyListeners(); // 상태 변경 알림
  }
}
