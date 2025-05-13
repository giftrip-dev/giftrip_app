import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:provider/provider.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/widgets/banner/event_banner.dart';
import 'package:myong/core/widgets/section_divider.dart';
import 'package:myong/features/home/view_models/product_view_model.dart';
import 'package:myong/features/home/widgets/home_app_bar.dart';
import 'package:myong/features/home/widgets/home_feature_tab.dart';
import 'package:myong/features/home/widgets/product/product_carousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                  SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '새로 들어왔어요!',
                          style: body_S,
                        ),
                        SizedBox(height: 4),
                        Text(
                          '🔥NEW',
                          style: title_M.copyWith(color: AppColors.labelStrong),
                        ),
                      ],
                    ),
                  ),
                  const ProductCarousel(section: ProductSection.newArrivals),
                  SizedBox(
                    height: 24,
                  ),
                  const SectionDivider(),

                  // 4) 베스트 섹션
                  SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '꾸준히 인기있는 스테디셀러',
                          style: body_S,
                        ),
                        SizedBox(height: 4),
                        Text(
                          '🔥BEST',
                          style: title_M.copyWith(color: AppColors.labelStrong),
                        ),
                      ],
                    ),
                  ),
                  const ProductCarousel(section: ProductSection.bestSellers),
                  SizedBox(
                    height: 24,
                  ),
                  const SectionDivider(),

                  // 5) 타임 딜 섹션
                  SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '놓치면 후회 할 초특가 할인!',
                          style: body_S,
                        ),
                        SizedBox(height: 4),
                        Text(
                          '🔥지금 구매 찬스',
                          style: title_M.copyWith(color: AppColors.labelStrong),
                        ),
                      ],
                    ),
                  ),
                  const ProductCarousel(section: ProductSection.timeDeals),
                  SizedBox(
                    height: 24,
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
