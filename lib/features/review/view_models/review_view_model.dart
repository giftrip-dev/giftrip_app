import 'package:flutter/material.dart';
import 'package:myong/core/utils/page_meta.dart';
import 'package:myong/features/review/models/review_model.dart';
import 'package:myong/features/review/repositories/review_repo.dart';

class ReviewViewModel extends ChangeNotifier {
  final ReviewRepo _reviewRepo;

  ReviewViewModel({
    ReviewRepo? reviewRepo,
  }) : _reviewRepo = reviewRepo ?? ReviewRepo();

  // 상태 관리
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _hasMoreData = true;

  // 데이터
  List<ReviewModel> _reviews = [];
  ReviewModel? _selectedReview;
  PageMeta? _pageMeta;

  // 게터
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  List<ReviewModel> get reviews => _reviews;
  ReviewModel? get selectedReview => _selectedReview;
  bool get hasMoreData => _hasMoreData;
  int get totalReviews => _pageMeta?.totalItems ?? 0;
  double get averageRating {
    if (_reviews.isEmpty) return 0;
    final sum = _reviews.fold(0.0, (prev, review) => prev + review.rating);
    return sum / _reviews.length;
  }

  /// 리뷰 목록 조회
  Future<void> fetchReviews({
    required String productId,
    String productType = 'experience',
    int page = 1,
    int limit = 10,
    bool refresh = false,
  }) async {
    if (refresh) {
      _reviews = [];
      _hasMoreData = true;
      _pageMeta = null;
    }

    if (!_hasMoreData && !refresh) return;

    _setLoading(true);
    _clearError();

    try {
      final response = await _reviewRepo.getReviews(
        productId: productId,
        productType: productType,
        page: page,
        limit: limit,
      );

      if (refresh || page == 1) {
        _reviews = response.items;
      } else {
        _reviews = [..._reviews, ...response.items];
      }

      _pageMeta = response.meta;
      _hasMoreData = page < response.meta.totalPages;
    } catch (e) {
      _setError('리뷰 목록을 불러오는 중 오류가 발생했습니다: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// 리뷰 상세 조회
  Future<void> fetchReviewDetail(String reviewId) async {
    _setLoading(true);
    _clearError();

    try {
      final review = await _reviewRepo.getReviewDetail(reviewId);
      _selectedReview = review;
    } catch (e) {
      _setError('리뷰 상세 정보를 불러오는 중 오류가 발생했습니다: $e');
    } finally {
      _setLoading(false);
    }
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
    _setLoading(true);
    _clearError();

    try {
      await _reviewRepo.createReview(
        productId: productId,
        productType: productType,
        title: title,
        content: content,
        rating: rating,
        thumbnailUrl: thumbnailUrl,
      );
      // 작성 성공 후 리뷰 목록 새로고침
      await fetchReviews(
        productId: productId,
        productType: productType,
        refresh: true,
      );
    } catch (e) {
      _setError('리뷰 작성 중 오류가 발생했습니다: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// 리뷰 수정
  Future<void> updateReview({
    required String reviewId,
    required String productId,
    required String productType,
    String? title,
    String? content,
    double? rating,
    String? thumbnailUrl,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _reviewRepo.updateReview(
        reviewId: reviewId,
        title: title,
        content: content,
        rating: rating,
        thumbnailUrl: thumbnailUrl,
      );
      // 수정 성공 후 리뷰 목록 새로고침
      await fetchReviews(
        productId: productId,
        productType: productType,
        refresh: true,
      );
    } catch (e) {
      _setError('리뷰 수정 중 오류가 발생했습니다: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// 리뷰 삭제
  Future<void> deleteReview({
    required String reviewId,
    required String productId,
    required String productType,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _reviewRepo.deleteReview(reviewId);
      // 삭제 성공 후 리뷰 목록 새로고침
      await fetchReviews(
        productId: productId,
        productType: productType,
        refresh: true,
      );
    } catch (e) {
      _setError('리뷰 삭제 중 오류가 발생했습니다: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// 리뷰에 대한 통계 정보 계산
  Map<int, int> getRatingDistribution() {
    final distribution = <int, int>{
      5: 0,
      4: 0,
      3: 0,
      2: 0,
      1: 0,
    };

    for (var review in _reviews) {
      final rating = review.rating.round();
      if (rating >= 1 && rating <= 5) {
        distribution[rating] = (distribution[rating] ?? 0) + 1;
      }
    }

    return distribution;
  }

  // 상태 관리 헬퍼 메서드
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _hasError = true;
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _hasError = false;
    _errorMessage = '';
  }
}
