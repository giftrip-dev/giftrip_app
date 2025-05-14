import 'package:flutter/material.dart';
import 'package:myong/core/widgets/section_divider.dart';
import 'package:myong/features/shared/widgets/product_detail_image_section.dart';
import 'package:myong/features/shared/widgets/product_policy_section.dart';
import 'package:provider/provider.dart';
import 'package:myong/core/constants/item_type.dart';
import 'package:myong/features/experience/view_models/experience_view_model.dart';
import 'package:myong/features/review/widgets/review_list.dart';
import 'package:myong/features/shared/widgets/product_app_bar.dart';
import 'package:myong/features/shared/widgets/product_basic_info_section.dart';

class ExperienceDetailScreen extends StatefulWidget {
  final String experienceId;

  const ExperienceDetailScreen({
    required this.experienceId,
    super.key,
  });

  @override
  State<ExperienceDetailScreen> createState() => _ExperienceDetailScreenState();
}

class _ExperienceDetailScreenState extends State<ExperienceDetailScreen> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 상세 정보 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<ExperienceViewModel>()
          .fetchExperienceDetail(widget.experienceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProductAppBar(
        title: '',
        itemId: widget.experienceId,
        type: ProductItemType.experience,
      ),
      body: Consumer<ExperienceViewModel>(
        builder: (context, viewModel, child) {
          final experience = viewModel.selectedExperience;

          // 로딩 중이거나 데이터가 없는 경우
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 에러 발생
          if (viewModel.hasError || experience == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('데이터를 불러오는 중 오류가 발생했습니다.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<ExperienceViewModel>()
                          .fetchExperienceDetail(widget.experienceId);
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
                  title: experience.title,
                  thumbnailUrl: experience.thumbnailUrl,
                  badges: experience.badges,
                  location: experience.location,
                  phoneNumber: experience.managerPhoneNumber,
                  memo: experience.description,
                  relatedLink: experience.relatedLink,
                ),
                const SectionDivider(),

                // 리뷰 목록
                ReviewList(
                  productId: widget.experienceId,
                  productType: 'experience',
                  productTitle: experience.title,
                  productThumbnailUrl: experience.thumbnailUrl,
                  productPrice: experience.finalPrice,
                ),
                const SectionDivider(),

                // 상세 이미지
                ProductDetailImageSection(
                  croppedImageUrl: experience.croppedDetailImageUrl,
                  detailImageUrl: experience.detailImageUrl,
                ),
                const SectionDivider(),

                // 문의하기 섹션
                ProductPolicySection(
                  title: '문의하기',
                  sectionTitle: experience.inquiryInfo.title,
                  sectionContent: experience.inquiryInfo.content,
                ),
                const SectionDivider(),

                // 변경 및 취소 섹션
                ProductPolicySection(
                  title: '변경 및 취소',
                  sectionTitle: experience.changeInfo.title,
                  sectionContent: experience.changeInfo.content,
                ),
                const SectionDivider(),
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
