import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/widgets/banner/event_banner.dart';
import 'package:giftrip/core/widgets/section_divider.dart';
import 'package:giftrip/features/cart/view_models/cart_view_model.dart';
import 'package:giftrip/features/home/view_models/product_view_model.dart';
import 'package:giftrip/features/home/widgets/home_app_bar.dart';
import 'package:giftrip/features/home/widgets/home_feature_tab.dart';
import 'package:giftrip/features/home/widgets/product/product_section_block.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // 홈 화면 로드 시 장바구니 데이터 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartViewModel>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductViewModel(),
      child: Scaffold(
        appBar: const HomeAppBar(),
        body: Consumer<ProductViewModel>(
          builder: (context, vm, child) {
            return RefreshIndicator(
              onRefresh: () async {
                await vm.fetchNewProducts(page: 1);
                await vm.fetchBestProducts(page: 1);
                await vm.fetchTimeDealProducts(page: 1);
              },
              color: AppColors.primary,
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  // 1) 이벤트 배너
                  const EventBannerWidget(),

                  // 2) 홈 피처 탭
                  const HomeFeatureTab(),
                  const SectionDivider(),

                  // 3) 신상품 섹션
                  const ProductSectionBlock(
                    subtitle: '새로 들어왔어요!',
                    title: '🔥NEW',
                    section: ProductSection.newArrivals,
                  ),

                  // 4) 베스트 섹션
                  const ProductSectionBlock(
                    subtitle: '꾸준히 인기있는 스테디셀러',
                    title: '🔥BEST',
                    section: ProductSection.bestSellers,
                  ),

                  // 5) 타임 딜 섹션
                  const ProductSectionBlock(
                    subtitle: '놓치면 후회 할 초특가 할인!',
                    title: '🔥지금 구매 찬스',
                    section: ProductSection.timeDeals,
                    hideBottomDivider: true,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
