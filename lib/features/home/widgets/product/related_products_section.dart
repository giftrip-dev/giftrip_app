import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/features/home/models/product_model.dart';
import 'package:giftrip/features/home/view_models/product_view_model.dart';
import 'package:giftrip/features/home/widgets/product/product_carousel.dart';

/// 관련 상품 섹션 위젯
/// 상품 상세, 체험 상세, 체험단 상세 등에서 재사용 가능
class RelatedProductsSection extends StatefulWidget {
  /// 섹션 제목 (예: '이런 체험은 어떠세요?', '이런 상품은 어떠세요?')
  final String title;

  /// 상품 타입 (어떤 종류의 관련 상품을 보여줄지)
  final ProductType productType;

  /// 현재 보고 있는 상품 ID (관련 상품 추천 시 제외용)
  final String? productId;

  /// 한 번에 보여줄 상품 수
  final int pageSize;

  const RelatedProductsSection({
    Key? key,
    required this.title,
    required this.productType,
    this.productId,
    this.pageSize = 10,
  }) : super(key: key);

  @override
  State<RelatedProductsSection> createState() => _RelatedProductsSectionState();
}

class _RelatedProductsSectionState extends State<RelatedProductsSection> {
  @override
  void initState() {
    super.initState();

    // 위젯이 렌더링된 후 관련 상품 데이터 로드
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadRelatedProducts();
    });
  }

  Future<void> _loadRelatedProducts() async {
    final vm = context.read<ProductViewModel>();
    await vm.fetchRelatedProducts(
      productType: widget.productType,
      productId: widget.productId,
      limit: widget.pageSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, vm, child) {
        // 로딩 중이고 데이터가 없는 경우
        if (vm.isRelatedLoading && vm.relatedList.isEmpty) {
          return _buildLoadingState();
        }

        // 데이터가 없는 경우
        if (!vm.isRelatedLoading && vm.relatedList.isEmpty) {
          return const SizedBox.shrink(); // 관련 상품이 없으면 섹션 자체를 표시하지 않음
        }

        // 정상 데이터 표시
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Text(
                  widget.title,
                  style: title_L,
                ),
              ),

              // 관련 상품 캐러셀
              ProductCarousel(
                section: ProductSection.relatedProducts,
                isHomeScreen: false, // 상품 자체의 뱃지를 사용하도록 설정
                relatedToProductType: widget.productType,
                relatedToProductId: widget.productId,
              ),

              // 하단 여백
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  /// 로딩 상태 위젯
  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Text(
              widget.title,
              style: title_L,
            ),
          ),
          const SizedBox(
            height: 150,
            child: Center(child: CircularProgressIndicator()),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
