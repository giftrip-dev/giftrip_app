import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:myong/features/home/view_models/product_view_model.dart';
import 'package:myong/features/home/models/product_model.dart';
import 'package:myong/features/home/widgets/product/product_item.dart';

/// 가로 슬라이드 & 무한 페칭 캐러셀
class ProductCarousel extends StatefulWidget {
  final ProductSection section;

  /// 홈 화면에서 표시될 때는 true, 다른 화면에서 표시될 때는 false
  final bool isHomeScreen;

  /// 관련 상품 로딩에 필요한 파라미터 (section이 relatedProducts일 때 사용)
  final ProductType? relatedToProductType;
  final String? relatedToProductId;

  const ProductCarousel({
    Key? key,
    required this.section,
    this.isHomeScreen = true,
    this.relatedToProductType,
    this.relatedToProductId,
  }) : super(key: key);

  @override
  State<ProductCarousel> createState() => _ProductCarouselState();
}

class _ProductCarouselState extends State<ProductCarousel> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    SchedulerBinding.instance.addPostFrameCallback((_) => _initFetch());
  }

  void _initFetch() {
    final vm = context.read<ProductViewModel>();
    switch (widget.section) {
      case ProductSection.newArrivals:
        vm.fetchNewProducts();
        break;
      case ProductSection.bestSellers:
        vm.fetchBestProducts();
        break;
      case ProductSection.timeDeals:
        vm.fetchTimeDealProducts();
        break;
      case ProductSection.relatedProducts:
        // 관련 상품 섹션인 경우 fetchRelatedProducts()는 RelatedProductsSection에서 직접 호출
        break;
    }
  }

  void _onScroll() {
    final vm = context.read<ProductViewModel>();
    final pos = _controller.position;
    if (pos.pixels >= pos.maxScrollExtent - 100 && !vm.isLoading) {
      switch (widget.section) {
        case ProductSection.newArrivals:
          if (vm.hasMoreNew) vm.nextPageNew();
          break;
        case ProductSection.bestSellers:
          if (vm.hasMoreBest) vm.nextPageBest();
          break;
        case ProductSection.timeDeals:
          if (vm.hasMoreTimeDeal) vm.nextPageTimeDeal();
          break;
        case ProductSection.relatedProducts:
          if (vm.hasMoreRelated && widget.relatedToProductType != null) {
            vm.nextPageRelated(
              productType: widget.relatedToProductType!,
              productId: widget.relatedToProductId,
            );
          }
          break;
      }
    }
  }

  /// 섹션에 따른 배지 타입 결정
  ProductTagType _getBadgeTypeForSection() {
    switch (widget.section) {
      case ProductSection.newArrivals:
        return ProductTagType.newArrival;
      case ProductSection.bestSellers:
        return ProductTagType.bestSeller;
      case ProductSection.timeDeals:
      case ProductSection.relatedProducts:
      default:
        return ProductTagType.almostSoldOut; // 타임딜이나 기타 섹션
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (_, vm, __) {
        final List<ProductModel> items;

        // 섹션에 따라 어떤 데이터를 사용할지 결정
        switch (widget.section) {
          case ProductSection.newArrivals:
            items = vm.newList;
            break;
          case ProductSection.bestSellers:
            items = vm.bestList;
            break;
          case ProductSection.timeDeals:
            items = vm.timeDealList;
            break;
          case ProductSection.relatedProducts:
            items = vm.relatedList;
            break;
        }

        if (items.isEmpty && vm.isLoading) {
          return const SizedBox(
            height: 150,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return SingleChildScrollView(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < items.length; i++) ...[
                ProductItem(
                  product: items[i],
                  // 홈 화면에서는 섹션 기반 배지 사용, 다른 화면에서는 상품 자체 배지 사용
                  badgeType:
                      widget.isHomeScreen ? _getBadgeTypeForSection() : null,
                  useProductBadges: !widget.isHomeScreen,
                ),
                if (i != items.length - 1) const SizedBox(width: 12),
              ],
              if (vm.isLoading)
                SizedBox(
                  width: 156,
                  height: 145, // 상품 이미지 높이와 동일하게 맞춤
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
