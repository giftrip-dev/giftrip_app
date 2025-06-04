import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:giftrip/core/widgets/empty/empty_state_widget.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/features/home/view_models/product_view_model.dart';
import 'package:giftrip/features/home/models/product_model.dart';
import 'package:giftrip/features/home/widgets/product/product_thumbnail_item.dart';
import 'package:giftrip/features/experience/screens/experience_detail_screen.dart';
import 'package:giftrip/features/lodging/screens/lodging_detail_screen.dart';
import 'package:giftrip/features/shopping/screens/shopping_detail_screen.dart';
import 'package:giftrip/features/tester/screens/tester_detail_screen.dart';

/// 가로 슬라이드 & 무한 페칭 캐러셀
class ProductCarousel extends StatefulWidget {
  final ProductSection section;

  /// 관련 상품 로딩에 필요한 파라미터 (section이 relatedProducts일 때 사용)
  final ProductType? relatedToProductType;
  final String? relatedToProductId;

  const ProductCarousel({
    Key? key,
    required this.section,
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
    if (pos.pixels >= pos.maxScrollExtent - 100) {
      switch (widget.section) {
        case ProductSection.newArrivals:
          if (vm.hasMoreNew && !vm.isNewLoading) vm.nextPageNew();
          break;
        case ProductSection.bestSellers:
          if (vm.hasMoreBest && !vm.isBestLoading) vm.nextPageBest();
          break;
        case ProductSection.timeDeals:
          if (vm.hasMoreTimeDeal && !vm.isTimeDealLoading)
            vm.nextPageTimeDeal();
          break;
        case ProductSection.relatedProducts:
          if (vm.hasMoreRelated &&
              !vm.isRelatedLoading &&
              widget.relatedToProductType != null) {
            vm.nextPageRelated(
              productType: widget.relatedToProductType!,
              productId: widget.relatedToProductId,
            );
          }
          break;
      }
    }
  }

  void _onProductTap(BuildContext context, ProductModel product) {
    switch (product.productType) {
      case ProductType.experience:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExperienceDetailScreen(
              experienceId: product.id,
            ),
          ),
        );
        break;
      case ProductType.experienceGroup:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TesterDetailScreen(
              testerId: product.id,
            ),
          ),
        );
        break;
      case ProductType.product:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShoppingDetailScreen(
              shoppingId: product.id,
            ),
          ),
        );
        break;
      case ProductType.lodging:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LodgingDetailScreen(
              lodgingId: product.id,
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (_, vm, __) {
        final List<ProductModel> items;
        final bool isLoading;

        // 섹션에 따라 어떤 데이터를 사용할지 결정
        switch (widget.section) {
          case ProductSection.newArrivals:
            items = vm.newList;
            isLoading = vm.isNewLoading;
            break;
          case ProductSection.bestSellers:
            items = vm.bestList;
            isLoading = vm.isBestLoading;
            break;
          case ProductSection.timeDeals:
            items = vm.timeDealList;
            isLoading = vm.isTimeDealLoading;
            break;
          case ProductSection.relatedProducts:
            items = vm.relatedList;
            isLoading = vm.isRelatedLoading;
            break;
        }

        // 로딩 중이고 데이터가 없는 경우
        if (isLoading && items.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // 데이터가 없는 경우
        if (items.isEmpty && !isLoading) {
          return const EmptyStateWidget(
            message: '아직 등록된 상품이 없어요',
            icon: Icons.shopping_bag_outlined,
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
                ProductThumbnailItem(
                  product: items[i],
                  onTap: () => _onProductTap(context, items[i]),
                ),
                if (i != items.length - 1) const SizedBox(width: 12),
              ],
              if (isLoading)
                const SizedBox(
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
