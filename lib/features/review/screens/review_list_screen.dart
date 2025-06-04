import 'package:flutter/material.dart';
import 'package:giftrip/features/home/models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/app_bar/search_app_bar.dart';
import 'package:giftrip/core/widgets/image/custom_image.dart';
import 'package:giftrip/core/widgets/rating/rating_display.dart';
import 'package:giftrip/features/review/view_models/review_view_model.dart';
import 'package:giftrip/features/review/widgets/review_item.dart';

class ProductSummaryModel {
  final String thumbnailUrl;
  final String title;
  final double averageRating;

  const ProductSummaryModel({
    required this.thumbnailUrl,
    required this.title,
    required this.averageRating,
  });
}

class ReviewListScreen extends StatefulWidget {
  final String productId;
  final ProductType productType;
  final ProductSummaryModel productSummary;

  const ReviewListScreen({
    Key? key,
    required this.productId,
    required this.productType,
    required this.productSummary,
  }) : super(key: key);

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // 스크롤 컨트롤러에 리스너 추가 (무한 스크롤)
    _scrollController.addListener(_onScroll);

    // 초기 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReviews();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // 스크롤 이벤트 처리
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreReviews();
    }
  }

  // 초기 리뷰 로드
  Future<void> _loadReviews() async {
    await context.read<ReviewViewModel>().fetchReviews(
          productId: widget.productId,
          productType: widget.productType,
          page: 1,
          limit: _itemsPerPage,
          refresh: true,
        );
  }

  // 추가 리뷰 로드
  Future<void> _loadMoreReviews() async {
    final viewModel = context.read<ReviewViewModel>();

    if (!viewModel.isLoading && viewModel.hasMoreData) {
      _currentPage++;
      await viewModel.fetchReviews(
        productId: widget.productId,
        productType: widget.productType,
        page: _currentPage,
        limit: _itemsPerPage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchAppBar(title: '상품 리뷰'),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Consumer<ReviewViewModel>(
          builder: (context, viewModel, child) {
            final reviews = viewModel.reviews;

            return Column(
              children: [
                // 상품 요약 정보
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildProductSummary(),
                ),

                const SizedBox(height: 30),

                // 구분선
                Container(
                  height: 1,
                  width: double.infinity,
                  color: AppColors.line,
                ),

                const SizedBox(height: 16),

                // 리뷰 섹션
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildReviewContent(viewModel, reviews),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // 상품 요약 아이템 위젯
  Widget _buildProductSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundAlternative,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 썸네일
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: CustomImage(
              imageUrl: widget.productSummary.thumbnailUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          // 상품명 및 평균 별점
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productSummary.title,
                  style: body_M,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // 평균 별점 표시
                RatingDisplay(
                  rating: widget.productSummary.averageRating,
                  starSize: 16,
                  starColor: AppColors.primarySoft,
                  ratingTextStyle:
                      subtitle_S.copyWith(color: AppColors.labelStrong),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 리뷰 목록 또는 없음 메시지
  Widget _buildReviewContent(ReviewViewModel viewModel, List reviews) {
    if (viewModel.isLoading && reviews.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 리뷰 섹션 제목
    final titleWidget = RichText(
      text: TextSpan(
        style: title_L.copyWith(color: AppColors.label),
        children: [
          TextSpan(text: '상품 리뷰 '),
          TextSpan(
            text: '${viewModel.totalReviews}',
            style: title_L.copyWith(color: AppColors.primaryStrong),
          ),
          TextSpan(text: '개'),
        ],
      ),
    );

    if (reviews.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleWidget,
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.backgroundAlternative,
              borderRadius: BorderRadius.circular(12),
            ),
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              '등록된 리뷰가 없어요',
              style: body_S.copyWith(color: AppColors.labelAlternative),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 리뷰 섹션 제목
        titleWidget,
        const SizedBox(height: 16),

        // 리뷰 목록
        Expanded(
          child: ListView.separated(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: reviews.length + (viewModel.hasMoreData ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index == reviews.length) {
                return viewModel.isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : const SizedBox.shrink();
              }
              return ReviewItem(review: reviews[index]);
            },
          ),
        ),
      ],
    );
  }
}
