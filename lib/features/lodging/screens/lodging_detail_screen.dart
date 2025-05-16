import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/section_divider.dart';
import 'package:giftrip/features/shared/widgets/product_detail_image_section.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/features/lodging/view_models/lodging_view_model.dart';
import 'package:giftrip/features/shared/widgets/product_app_bar.dart';
import 'package:giftrip/features/shared/widgets/product_basic_info_section.dart';
import 'package:giftrip/features/shared/widgets/product_policy_section.dart';

import 'package:giftrip/features/home/models/product_model.dart';
import 'package:giftrip/features/home/widgets/product/related_products_section.dart';
import 'package:giftrip/features/review/widgets/review_list.dart';

class LodgingDetailScreen extends StatefulWidget {
  final String lodgingId;

  const LodgingDetailScreen({
    required this.lodgingId,
    super.key,
  });

  @override
  State<LodgingDetailScreen> createState() => _LodgingDetailScreenState();
}

class _LodgingDetailScreenState extends State<LodgingDetailScreen> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 상세 정보 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LodgingViewModel>().fetchLodgingDetail(widget.lodgingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProductAppBar(
        title: '',
        itemId: widget.lodgingId,
        type: ProductItemType.lodging,
      ),
      body: Consumer<LodgingViewModel>(
        builder: (context, viewModel, child) {
          final lodging = viewModel.selectedLodging;

          // 로딩 중이거나 데이터가 없는 경우
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 에러 발생
          if (viewModel.hasError || lodging == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('데이터를 불러오는 중 오류가 발생했습니다.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<LodgingViewModel>()
                          .fetchLodgingDetail(widget.lodgingId);
                    },
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 기본 정보 섹션
                ProductBasicInfoSection(
                  title: lodging.title,
                  thumbnailUrl: lodging.thumbnailUrl,
                  badges: lodging.badges,
                  location: lodging.location,
                  phoneNumber: lodging.managerPhoneNumber,
                  memo: lodging.description,
                  relatedLink: lodging.relatedLink,
                ),
                const SectionDivider(),

                // 리뷰 목록
                ReviewList(
                  productId: widget.lodgingId,
                  productType: 'lodging',
                  productTitle: lodging.title,
                  productThumbnailUrl: lodging.thumbnailUrl,
                  productPrice: lodging.finalPrice,
                ),
                const SectionDivider(),

                // 상세 이미지
                ProductDetailImageSection(
                  croppedImageUrl: lodging.croppedDetailImageUrl,
                  detailImageUrl: lodging.detailImageUrl,
                ),
                const SectionDivider(),

                // 문의하기 섹션
                ProductPolicySection(
                  title: '문의하기',
                  sectionTitle: lodging.inquiryInfo.title,
                  sectionContent: lodging.inquiryInfo.content,
                ),
                const SectionDivider(),

                // 변경 및 취소 섹션
                ProductPolicySection(
                  title: '변경 및 취소',
                  sectionTitle: lodging.changeInfo.title,
                  sectionContent: lodging.changeInfo.content,
                ),
                const SectionDivider(),

                // 관련 숙박 추천 섹션
                RelatedProductsSection(
                  title: '이런 숙박 어떠세요?',
                  productType: ProductType.lodging,
                  productId: widget.lodgingId,
                  pageSize: 5,
                ),
              ],
            ),
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
