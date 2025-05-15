import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/features/community/models/dto/post_dto.dart';
import 'package:giftrip/features/community/models/post_model.dart';

class CommunityRepo {
  final Dio _dio = DioClient().to();

  /// 커뮤니티 게시글 목록 조회
  Future<PostPageResponse> getCommunityList({
    required String sort,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get('/api/posts', queryParameters: {
        'page': page,
        'limit': limit,
        'sortBy': sort,
      });

      if (response.statusCode == 200) {
        return PostPageResponse.fromJson(response.data);
      } else {
        throw Exception('게시글 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('게시글 조회 API 요청 실패: $e');
    }
  }

  /// 내가 작성한 커뮤니티 게시글 목록 조회
  Future<PostPageResponse> getMyCommunityList({
    required String sort,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get('/api/posts/user', queryParameters: {
        'page': page,
        'limit': limit,
        'sortBy': sort,
      });

      if (response.statusCode == 200) {
        return PostPageResponse.fromJson(response.data);
      } else {
        throw Exception('내가 작성한 게시글 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('내가 작성한 게시글 조회 API 요청 실패: $e');
    }
  }

  /// 커뮤니티 게시글 상세 조회
  Future<PostModel> getPostDetail({postId}) async {
    try {
      final response = await _dio.get("/api/posts/$postId");

      if (response.statusCode == 200) {
        return PostModel.fromJson(response.data);
      } else {
        throw Exception('게시글 상세 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('게시글 상세 조회 API 요청 실패: $e');
    }
  }

  /// 커뮤니티 게시글 좋아요 요청
  Future<bool> postLike({required String postId}) async {
    try {
      final response = await _dio.post('/api/likes/$postId');

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('게시글 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('게시글 조회 API 요청 실패: $e');
    }
  }

  /// 커뮤니티 게시글 좋아요 취소 요청
  Future<bool> deleteLike({required String postId}) async {
    try {
      final response = await _dio.delete('/api/likes/$postId');

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('게시글 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('게시글 조회 API 요청 실패: $e');
    }
  }

  /// 커뮤니티 게시글 작성 요청
  Future<PostModel> addCommunityPost(
      {required PostCreateRequestDto postData}) async {
    try {
      final response = await _dio.post(
        '/api/posts',
        data: postData.toJson(),
      );

      if (response.statusCode == 201) {
        return PostModel.fromJson(response.data);
      } else {
        throw Exception('게시글 생성 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('게시글 생성 API 요청 실패: $e');
    }
  }

  /// 커뮤니티 게시글 수정 요청
  Future<PostModel> updateCommunityPost({
    required String postId,
    required PostCreateRequestDto postData,
  }) async {
    try {
      final response = await _dio.patch(
        '/api/posts/$postId',
        data: postData.toJson(),
      );

      if (response.statusCode == 200) {
        return PostModel.fromJson(response.data);
      } else {
        throw Exception('게시글 수정 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('게시글 수정 API 요청 실패: $e');
    }
  }

  /// 커뮤니티 게시글 삭제
  Future<bool> deletePost({required String postId}) async {
    try {
      final response = await _dio.delete(
        '/api/posts/$postId',
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('게시글 삭제 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('게시글 삭제 API 요청 실패: $e');
    }
  }

  /// 검색 게시글 조회
  Future<PostPageResponse> getSearchCommunityList({
    required String keyword,
    required String sort,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get('/api/posts/search', queryParameters: {
        'page': page,
        'limit': limit,
        'keyword': keyword,
        'sortBy': sort,
      });

      if (response.statusCode == 200) {
        return PostPageResponse.fromJson(response.data);
      } else {
        throw Exception('게시글 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('게시글 조회 API 요청 실패: $e');
    }
  }
}
