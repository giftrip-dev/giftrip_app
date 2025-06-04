import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/section_divider.dart';
import 'package:giftrip/shared/widgets/product/product_description_section.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/features/shopping/view_models/shopping_view_model.dart';
import 'package:giftrip/features/shopping/widgets/shopping_purchase_bottom_bar.dart';
import 'package:giftrip/shared/widgets/product/product_app_bar.dart';
import 'package:giftrip/shared/widgets/product/product_basic_info_section.dart';
import 'package:giftrip/shared/widgets/product/product_policy_section.dart';
import 'package:giftrip/features/home/models/product_model.dart';
import 'package:giftrip/features/home/widgets/product/related_products_section.dart';
import 'package:giftrip/features/review/widgets/review_list.dart';

class ShoppingDetailScreen extends StatefulWidget {
  final String shoppingId;

  const ShoppingDetailScreen({
    required this.shoppingId,
    super.key,
  });

  @override
  State<ShoppingDetailScreen> createState() => _ShoppingDetailScreenState();
}

class _ShoppingDetailScreenState extends State<ShoppingDetailScreen> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 상세 정보 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShoppingViewModel>().fetchShoppingDetail(widget.shoppingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProductAppBar(
        title: '',
        itemId: widget.shoppingId,
        type: ProductItemType.product,
      ),
      body: Consumer<ShoppingViewModel>(
        builder: (context, viewModel, child) {
          final shopping = viewModel.selectedShopping;

          // 로딩 중이거나 데이터가 없는 경우
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 에러 발생
          if (viewModel.hasError || shopping == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('데이터를 불러오는 중 오류가 발생했습니다.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<ShoppingViewModel>()
                          .fetchShoppingDetail(widget.shoppingId);
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
                        title: shopping.name,
                        thumbnailUrl: shopping.thumbnailUrl,
                        badges: shopping.itemTags,
                        location: shopping.manufacturer,
                        phoneNumber: shopping.managerPhoneNumber,
                        memo: shopping.description,
                        relatedLink: shopping.relatedLink,
                      ),
                      const SectionDivider(),

                      // 리뷰 목록
                      ReviewList(
                        productId: widget.shoppingId,
                        productType: ProductType.experienceGroup,
                        productTitle: shopping.name,
                        productThumbnailUrl: shopping.thumbnailUrl,
                        averageRating: shopping.averageRating,
                      ),
                      const SectionDivider(),

                      // 상품 설명 섹션 (퀼 에디터)
                      ProductDescriptionSection(
                        title: '상품 상세 설명',
                        content: shopping.content,
                      ),

                      const SectionDivider(),

                      // 문의하기 섹션
                      ProductPolicySection(
                        title: '문의하기',
                        sectionTitle: shopping.inquiryInfo.title,
                        sectionContent: shopping.inquiryInfo.content,
                      ),
                      const SectionDivider(),

                      // 변경 및 취소 섹션
                      ProductPolicySection(
                        title: '변경 및 취소',
                        sectionTitle: shopping.changeInfo.title,
                        sectionContent: shopping.changeInfo.content,
                      ),
                      const SectionDivider(),

                      // 관련 쇼핑 추천 섹션
                      RelatedProductsSection(
                        title: '이런 상품 어떠세요?',
                        productType: ProductType.product,
                        productId: widget.shoppingId,
                        pageSize: 5,
                      ),

                      // 하단 여백 (바텀바 가리지 않도록)
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // 구매 바텀바
              ShoppingPurchaseBottomBar(
                originalPrice: shopping.originalPrice,
                finalPrice: shopping.finalPrice,
                discountRate: shopping.discountRate,
                soldOut: shopping.soldOut,
              ),
            ],
          );
        },
      ),
    );
  }
}

// int 확장 메서드 - 천 단위 콤마 추가
extension IntExtension on int {
  String toLocaleString() {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
