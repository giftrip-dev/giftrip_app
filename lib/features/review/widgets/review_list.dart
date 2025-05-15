import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/features/review/view_models/review_view_model.dart';
import 'package:giftrip/features/review/widgets/review_item.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/features/review/screens/review_list_screen.dart';

class ReviewList extends StatefulWidget {
  final String productId;
  final String productType;
  final String productTitle;
  final String productThumbnailUrl;
  final int productPrice;

  const ReviewList({
    required this.productId,
    this.productType = 'experience',
    required this.productTitle,
    required this.productThumbnailUrl,
    required this.productPrice,
    super.key,
  });

  @override
  State<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  final int _itemsPerPage = 4;

  @override
  void initState() {
    super.initState();

    // 초기 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReviews();
    });
  }

  // 리뷰 로드
  Future<void> _loadReviews() async {
    await context.read<ReviewViewModel>().fetchReviews(
          productId: widget.productId,
          productType: widget.productType,
          page: 1,
          limit: _itemsPerPage,
          refresh: true,
        );
  }

  // 전체 리뷰 페이지로 이동
  void _navigateToAllReviews() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewListScreen(
          productId: widget.productId,
          productType: widget.productType,
          productSummary: ProductSummaryModel(
            thumbnailUrl: widget.productThumbnailUrl,
            title: widget.productTitle,
            price: widget.productPrice,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewViewModel>(
      builder: (context, viewModel, child) {
        final reviews = viewModel.reviews;

        if (viewModel.isLoading && reviews.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 리뷰 섹션 제목
              RichText(
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
              ),

              const SizedBox(height: 16),

              // 리뷰가 없는 경우 메시지 표시
              if (reviews.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundAlternative,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    '아직 등록된 리뷰가 없어요',
                    style: body_S.copyWith(color: AppColors.labelAlternative),
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 리뷰 목록
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: reviews.length > _itemsPerPage
                          ? _itemsPerPage
                          : reviews.length,
                      itemBuilder: (context, index) {
                        final isLastItem = index ==
                            (reviews.length > _itemsPerPage
                                ? _itemsPerPage - 1
                                : reviews.length - 1);

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: isLastItem ? 0 : 12,
                          ),
                          child: ReviewItem(review: reviews[index]),
                        );
                      },
                    ),

                    // 더보기 버튼
                    if (viewModel.totalReviews > _itemsPerPage)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: CTAButton(
                          isEnabled: true,
                          onPressed: _navigateToAllReviews,
                          text: '더보기',
                          type: CTAButtonType.outline,
                          size: CTAButtonSize.large,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
