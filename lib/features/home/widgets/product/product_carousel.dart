import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:myong/features/home/view_models/product_view_model.dart';
import 'package:myong/features/home/models/product.dart';
import 'package:myong/features/home/widgets/product/product_item.dart';

/// 가로 슬라이드 & 무한 페칭 캐러셀
class ProductCarousel extends StatefulWidget {
  final ProductSection section;
  const ProductCarousel({Key? key, required this.section}) : super(key: key);

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
    if (widget.section == ProductSection.newArrivals) {
      vm.fetchNewProducts();
    } else {
      vm.fetchBestProducts();
    }
  }

  void _onScroll() {
    final vm = context.read<ProductViewModel>();
    final pos = _controller.position;
    if (pos.pixels >= pos.maxScrollExtent - 100 &&
        !vm.isLoading &&
        (widget.section == ProductSection.newArrivals
            ? vm.hasMoreNew
            : vm.hasMoreBest)) {
      if (widget.section == ProductSection.newArrivals) {
        vm.nextPageNew();
      } else {
        vm.nextPageBest();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (_, vm, __) {
        final items = widget.section == ProductSection.newArrivals
            ? vm.newList
            : vm.bestList;

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
                  badgeType: widget.section == ProductSection.newArrivals
                      ? ItemBadgeType.newArrival
                      : widget.section == ProductSection.bestSellers
                          ? ItemBadgeType.bestSeller
                          : ItemBadgeType.almostSoldOut,
                ),
                if (i != items.length - 1) const SizedBox(width: 12),
              ],
              if (vm.isLoading)
                const SizedBox(
                  width: 156,
                  child: Center(child: CircularProgressIndicator()),
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
