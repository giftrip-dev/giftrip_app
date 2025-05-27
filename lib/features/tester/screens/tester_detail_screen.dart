import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/section_divider.dart';
import 'package:giftrip/shared/widgets/product/product_detail_image_section.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/features/tester/view_models/tester_view_model.dart';
import 'package:giftrip/features/tester/widgets/tester_purchase_bottom_bar.dart';
import 'package:giftrip/shared/widgets/product/product_app_bar.dart';
import 'package:giftrip/shared/widgets/product/product_basic_info_section.dart';
import 'package:giftrip/shared/widgets/product/product_policy_section.dart';
import 'package:giftrip/features/home/models/product_model.dart';
import 'package:giftrip/features/home/widgets/product/related_products_section.dart';
import 'package:giftrip/features/review/widgets/review_list.dart';

class TesterDetailScreen extends StatefulWidget {
  final String testerId;

  const TesterDetailScreen({
    required this.testerId,
    super.key,
  });

  @override
  State<TesterDetailScreen> createState() => _TesterDetailScreenState();
}

class _TesterDetailScreenState extends State<TesterDetailScreen> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 상세 정보 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TesterViewModel>().fetchTesterDetail(widget.testerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProductAppBar(
        title: '',
        itemId: widget.testerId,
        type: ProductItemType.experienceGroup,
      ),
      body: Consumer<TesterViewModel>(
        builder: (context, viewModel, child) {
          final tester = viewModel.selectedTester;

          // 로딩 중이거나 데이터가 없는 경우
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 에러 발생
          if (viewModel.hasError || tester == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('데이터를 불러오는 중 오류가 발생했습니다.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<TesterViewModel>()
                          .fetchTesterDetail(widget.testerId);
                    },
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // 콘텐츠 (스크롤 가능 영역)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 기본 정보 섹션
                      ProductBasicInfoSection(
                        title: tester.title,
                        thumbnailUrl: tester.thumbnailUrl,
                        badges: tester.badges,
                        location: tester.location,
                        phoneNumber: tester.managerPhoneNumber,
                        memo: tester.description,
                        relatedLink: tester.relatedLink,
                      ),
                      const SectionDivider(),

                      // 리뷰 목록
                      ReviewList(
                        productId: widget.testerId,
                        productType: ProductType.experienceGroup,
                        productTitle: tester.title,
                        productThumbnailUrl: tester.thumbnailUrl,
                        averageRating: tester.averageRating,
                      ),
                      const SectionDivider(),

                      // 상세 이미지
                      ProductDetailImageSection(
                        croppedImageUrl: tester.croppedDetailImageUrl,
                        detailImageUrl: tester.detailImageUrl,
                      ),
                      const SectionDivider(),

                      // 문의하기 섹션
                      ProductPolicySection(
                        title: '문의하기',
                        sectionTitle: tester.inquiryInfo.title,
                        sectionContent: tester.inquiryInfo.content,
                      ),
                      const SectionDivider(),

                      // 변경 및 취소 섹션
                      ProductPolicySection(
                        title: '변경 및 취소',
                        sectionTitle: tester.changeInfo.title,
                        sectionContent: tester.changeInfo.content,
                      ),
                      const SectionDivider(),

                      // 관련 체험단 추천 섹션
                      RelatedProductsSection(
                        title: '이런 체험단 어떠세요?',
                        productType: ProductType.experienceGroup,
                        productId: widget.testerId,
                        pageSize: 5,
                      ),

                      // 하단 여백 (바텀바 가리지 않도록)
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // 구매 바텀바
              TesterPurchaseBottomBar(
                originalPrice: tester.originalPrice,
                finalPrice: tester.finalPrice,
                discountRate: tester.discountRate,
                soldOut: tester.soldOut,
              ),
            ],
          );
        },
      ),
    );
  }
}
