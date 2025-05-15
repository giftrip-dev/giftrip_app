import 'package:flutter/material.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/features/community/models/comment_model.dart';
import 'package:giftrip/features/community/models/dto/comment_dto.dart';
import 'package:giftrip/features/community/repositories/comment_repo.dart';
import 'package:giftrip/features/community/view_models/community_view_model.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/utils/amplitude_logger.dart';

class CommentViewModel extends ChangeNotifier {
  final CommentRepo _commentRepo = CommentRepo();

  // 상태
  Map<String, List<CommentModel>> _commentsByPost = {}; // {postId: [댓글 목록]}
  Map<String, bool> _isLoadingByPost = {}; // {postId: 로딩 상태}

  // Getter
  List<CommentModel> getComments(String postId) =>
      _commentsByPost[postId] ?? [];
  bool isLoading(String postId) => _isLoadingByPost[postId] ?? false;

  /// 📌 게시글의 전체 댓글 개수 반환 메서드
  int getTotalCommentCount(String postId) {
    final comments = _commentsByPost[postId];

    if (comments == null) return 0;

    int countValidComments(List<CommentModel> commentList) {
      return commentList.fold(0, (sum, comment) {
        if (comment.deletedAt != null) {
          return sum +
              countValidComments(comment.replies); // 삭제된 댓글이라도 답글 개수는 포함
        }
        return sum + 1 + countValidComments(comment.replies);
      });
    }

    return countValidComments(comments);
  }

  /// 📌 댓글 목록 조회
  Future<void> fetchComments(String postId) async {
    _isLoadingByPost[postId] = true;
    notifyListeners();
    try {
      final response = await _commentRepo.getComments(postId);
      _commentsByPost[postId] = response;
    } catch (e) {
      logger.e('댓글 목록 불러오기 실패: $e');
    } finally {
      _isLoadingByPost[postId] = false;
      notifyListeners();
    }
  }

  /// 📌 댓글/답글 작성
  Future<bool> addComment(
      BuildContext context, String postId, CommentPostDto commentData) async {
    try {
      final newComment = await _commentRepo.addComment(postId, commentData);

      /// parentId가 존재하면 -> 부모 댓글의 `replies`에 추가
      if (commentData.parentId != null) {
        _addReplyToParent(postId, commentData.parentId!, newComment);
      } else {
        // 일반 댓글이면 -> 최상위 댓글 리스트에 추가
        _commentsByPost.putIfAbsent(postId, () => []).add(newComment);
      }

      // 📌 게시글의 전체 댓글 개수 업데이트
      final communityVM = context.read<CommunityViewModel>();
      communityVM.updateCommentCount(context, postId);

      notifyListeners();
      return true;
    } catch (e) {
      logger.e('댓글 작성 실패: $e');
      return false;
    }
  }

  /// 📌 댓글 삭제 (UI에서 완전히 제거하지 않고, deletedAt이 있을 경우 “작성자에 의해 삭제된 댓글입니다.”만 노출)
  Future<void> deleteComment(
      BuildContext context, String postId, String commentId) async {
    try {
      await _commentRepo.deleteComment(postId, commentId);

      final comments = _commentsByPost[postId];
      if (comments == null) return;

      // 재귀적으로 해당 comment를 찾아 deletedAt을 갱신
      _updateCommentDeleted(comments, commentId, '작성자에 의해 삭제된 댓글입니다.');

      // 📌 게시글의 전체 댓글 개수 업데이트
      final communityVM = context.read<CommunityViewModel>();
      communityVM.updateCommentCount(context, postId);

      notifyListeners();
    } catch (e) {
      logger.e('댓글 삭제 실패: $e');
    }
  }

  /// 📌 댓글 수정
  Future<bool> updateComment(BuildContext context, String postId,
      String commentId, CommentUpdateDto commentData) async {
    try {
      final updatedComment =
          await _commentRepo.updateComment(postId, commentId, commentData);

      final comments = _commentsByPost[postId];
      if (comments == null) return false;

      _updateCommentContent(comments, commentId, updatedComment);

      notifyListeners();
      return true;
    } catch (e) {
      logger.e('댓글 수정 실패: $e');
      return false;
    }
  }

  /// 댓글 내용 업데이트 메서드 (댓글 수정 시 사용)
  void _updateCommentContent(List<CommentModel> commentList,
      String updatedCommentId, CommentModel updatedComment) {
    for (var comment in commentList) {
      if (comment.id == updatedCommentId) {
        comment.content = updatedComment.content;
        comment.updatedAt = updatedComment.updatedAt;
        return;
      }
      if (comment.replies.isNotEmpty) {
        _updateCommentContent(
            comment.replies, updatedCommentId, updatedComment);
      }
    }
  }

  /// 삭제 일자 업데이트하는 메서드 (댓글 삭제 시 사용)
  void _updateCommentDeleted(List<CommentModel> commentList,
      String updatedCommentId, String updatedCommentContent) {
    for (var comment in commentList) {
      // 현재 댓글이 타겟이면 업데이트
      if (comment.id == updatedCommentId) {
        comment.deletedAt = DateTime.now();
        comment.content = updatedCommentContent;
        return;
      }
      // replies도 재귀적으로 확인
      if (comment.replies.isNotEmpty) {
        _updateCommentDeleted(
            comment.replies, updatedCommentId, updatedCommentContent);
      }
    }
  }

  /// 부모 댓글의 `replies` 리스트에 답글 추가하는 메서드
  void _addReplyToParent(String postId, String parentId, CommentModel reply) {
    final comments = _commentsByPost[postId] ?? [];

    for (var comment in comments) {
      if (comment.id == parentId) {
        comment.replies.add(reply);
        notifyListeners();
        return;
      }
    }

    logger.e('❌ 부모 댓글을 찾을 수 없음 (parentId: $parentId)');
  }
}
