import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/features/community/models/comment_model.dart';
import 'package:giftrip/features/community/models/dto/comment_dto.dart';

class CommentRepo {
  final Dio _dio = DioClient().to();

  /// 댓글 목록 조회
  Future<List<CommentModel>> getComments(String postId) async {
    try {
      final response = await _dio.get('/api/posts/$postId/comments');

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => CommentModel.fromJson(json))
            .toList();
      } else {
        throw Exception('댓글 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('댓글 조회 API 요청 실패: $e');
    }
  }

  /// 댓글 작성 요청
  Future<CommentModel> addComment(
      String postId, CommentPostDto commentData) async {
    try {
      final response = await _dio.post(
        '/api/posts/$postId/comments',
        data: commentData.toJson(),
      );

      if (response.statusCode == 201) {
        return CommentModel.fromJson(response.data); // 작성된 댓글 객체 반환
      } else {
        throw Exception('댓글 작성 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('댓글 작성 API 요청 실패: $e');
    }
  }

  /// 댓글 삭제 요청
  Future<bool> deleteComment(String postId, String commentId) async {
    try {
      final response =
          await _dio.delete('/api/posts/$postId/comments/$commentId');
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('댓글 삭제 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('댓글 삭제 API 요청 실패: $e');
    }
  }

  /// 댓글 수정 요청
  Future<CommentModel> updateComment(
      String postId, String commentId, CommentUpdateDto commentData) async {
    try {
      final response = await _dio.patch(
        '/api/posts/$postId/comments/$commentId',
        data: commentData.toJson(),
      );

      if (response.statusCode == 200) {
        return CommentModel.fromJson(response.data);
      } else {
        throw Exception('댓글 수정 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('댓글 수정 API 요청 실패: $e');
    }
  }
}
