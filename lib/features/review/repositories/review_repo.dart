import 'package:dio/dio.dart';
import 'package:myong/core/services/api_service.dart';
import 'package:myong/core/utils/page_meta.dart';
import 'package:myong/features/review/models/review_model.dart';
import 'package:myong/features/review/repositories/mock_review_data.dart';

class ReviewRepo {
  final Dio _dio = DioClient().to();

  /// 리뷰 목록 조회
  Future<ReviewPageResponse> getReviews({
    required String productId,
    String productType = 'experience', // experience, gift 등
    int page = 1,
    int limit = 10,
  }) async {
    // 데이터를 불러오는 동안 0.2초 딜레이
    await Future.delayed(const Duration(milliseconds: 200));

    // 목업 데이터 페이지네이션 처리
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    final items = mockReviewList.sublist(
      startIndex < mockReviewList.length ? startIndex : mockReviewList.length,
      endIndex < mockReviewList.length ? endIndex : mockReviewList.length,
    );

    return ReviewPageResponse(
      items: items,
      meta: PageMeta(
        currentPage: page,
        totalPages: (mockReviewList.length / limit).ceil(),
        totalItems: mockReviewList.length,
        itemsPerPage: limit,
      ),
    );

    // todo: API 호출 코드 (나중에 사용)
    /*try {
      final response = await _dio.get('/api/reviews', queryParameters: {
        'productId': productId,
        'productType': productType,
        'page': page,
        'limit': limit,
      });

      if (response.statusCode == 200) {
        return ReviewPageResponse.fromJson(response.data);
      } else {
        throw Exception('리뷰 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('리뷰 조회 API 요청 실패: $e');
    }*/
  }

  /// 리뷰 상세 조회
  Future<ReviewModel> getReviewDetail(String reviewId) async {
    // 데이터를 불러오는 동안 0.2초 딜레이
    await Future.delayed(const Duration(milliseconds: 200));

    // 목업 데이터에서 리뷰 찾기
    final review = mockReviewList.firstWhere(
      (review) => review.id == reviewId,
      orElse: () => throw Exception('리뷰를 찾을 수 없습니다.'),
    );

    return review;

    // todo: API 호출 코드 (나중에 사용)
    /*try {
      final response = await _dio.get('/api/reviews/$reviewId');

      if (response.statusCode == 200) {
        return ReviewModel.fromJson(response.data);
      } else {
        throw Exception('리뷰 상세 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('리뷰 상세 조회 API 요청 실패: $e');
    }*/
  }

  /// 리뷰 작성
  Future<void> createReview({
    required String productId,
    required String productType,
    required String title,
    required String content,
    required double rating,
    String? thumbnailUrl,
  }) async {
    // 리뷰 작성 성공 가정
    await Future.delayed(const Duration(milliseconds: 200));

    // todo: API 호출 코드 (나중에 사용)
    /*try {
      final response = await _dio.post(
        '/api/reviews',
        data: {
          'productId': productId,
          'productType': productType,
          'title': title,
          'content': content,
          'rating': rating,
          'thumbnailUrl': thumbnailUrl,
        },
      );

      if (response.statusCode != 201) {
        throw Exception('리뷰 작성 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('리뷰 작성 API 요청 실패: $e');
    }*/
  }

  /// 리뷰 수정
  Future<void> updateReview({
    required String reviewId,
    String? title,
    String? content,
    double? rating,
    String? thumbnailUrl,
  }) async {
    // 리뷰 수정 성공 가정
    await Future.delayed(const Duration(milliseconds: 200));

    // todo: API 호출 코드 (나중에 사용)
    /*try {
      final Map<String, dynamic> data = {};
      if (title != null) data['title'] = title;
      if (content != null) data['content'] = content;
      if (rating != null) data['rating'] = rating;
      if (thumbnailUrl != null) data['thumbnailUrl'] = thumbnailUrl;

      final response = await _dio.patch(
        '/api/reviews/$reviewId',
        data: data,
      );

      if (response.statusCode != 200) {
        throw Exception('리뷰 수정 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('리뷰 수정 API 요청 실패: $e');
    }*/
  }

  /// 리뷰 삭제
  Future<void> deleteReview(String reviewId) async {
    // 리뷰 삭제 성공 가정
    await Future.delayed(const Duration(milliseconds: 200));

    // todo: API 호출 코드 (나중에 사용)
    /*try {
      final response = await _dio.delete('/api/reviews/$reviewId');

      if (response.statusCode != 204) {
        throw Exception('리뷰 삭제 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('리뷰 삭제 API 요청 실패: $e');
    }*/
  }
}
