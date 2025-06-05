import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/section_divider.dart';
import 'package:giftrip/core/widgets/error/error_view.dart';
import 'package:giftrip/features/lodging/widgets/room_select_section.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/features/lodging/view_models/lodging_view_model.dart';
import 'package:giftrip/shared/widgets/product/product_app_bar.dart';
import 'package:giftrip/shared/widgets/product/product_basic_info_section.dart';
import 'package:giftrip/shared/widgets/product/product_policy_section.dart';
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
    // 화면 진입 시 상세 정보와 객실 리스트 로드
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final viewModel = context.read<LodgingViewModel>();
      await viewModel.fetchLodgingDetail(widget.lodgingId);
      await viewModel.fetchRoomList(widget.lodgingId, refresh: true);
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
            return ErrorView(
              onRetry: () {
                context
                    .read<LodgingViewModel>()
                    .fetchLodgingDetail(widget.lodgingId);
              },
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 기본 정보 섹션
                ProductBasicInfoSection(
                  title: lodging.name,
                  thumbnailUrl: lodging.thumbnailUrl,
                  badges: lodging.itemTags,
                  location: '${lodging.address1} ${lodging.address2}',
                  phoneNumber: lodging.managerPhoneNumber,
                  description: lodging.description,
                  relatedLink: lodging.relatedLink,
                ),
                const SectionDivider(),

                // 리뷰 목록
                ReviewList(
                  productId: widget.lodgingId,
                  productType: ProductType.lodging,
                  productTitle: lodging.name,
                  productThumbnailUrl: lodging.thumbnailUrl,
                  averageRating: 0,
                ),
                const SectionDivider(),

                // 객실 선택 섹션
                RoomSelectSection(
                  dateText: viewModel.stayDateText,
                  guestText:
                      '성인 ${viewModel.adultCount}${viewModel.childCount > 0 ? ', 아동 ${viewModel.childCount}' : ''}',
                ),
                const SectionDivider(),

                // 문의하기 섹션
                ProductPolicySection(
                  title: '문의하기',
                  sectionTitle: '문의하기',
                  sectionContent: '문의하기',
                ),
                const SectionDivider(),

                // 변경 및 취소 섹션
                ProductPolicySection(
                  title: '변경 및 취소',
                  sectionTitle: '변경 및 취소',
                  sectionContent: '변경 및 취소',
                ),
                const SectionDivider(),

                // 관련 숙소 추천 섹션
                RelatedProductsSection(
                  title: '이런 숙소 어떠세요?',
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
