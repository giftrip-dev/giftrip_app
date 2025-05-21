import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/app_bar/search_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/features/reservation/view_models/reservation_view_model.dart';
import 'package:giftrip/features/reservation/widgets/persistent_category_bar.dart';
import 'package:giftrip/features/reservation/widgets/reservation_list.dart';

class ReservationListScreen extends StatefulWidget {
  const ReservationListScreen({super.key});

  @override
  _ReservationListScreenState createState() => _ReservationListScreenState();
}

class _ReservationListScreenState extends State<ReservationListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchAppBar(title: '주문/예약'),
      body: Consumer<ReservationViewModel>(
        builder: (context, vm, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await vm.fetchReservationList(refresh: true);
            },
            color: AppColors.primary,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  // 2) 카테고리 필터링 바 (고정)

                  SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate: PersistentCategoryBarDelegate(
                      selectedCategory: vm.selectedCategory,
                      onCategoryChanged: (category) {
                        vm.changeCategory(category);
                      },
                      totalCount: vm.reservationList.length,
                    ),
                  ),
                ];
              },
              body: ReservationList(
                reservations: vm.reservationList,
                isLoading: vm.isLoading,
                hasError: vm.hasError,
                onLoadMore: vm.nextPage != null
                    ? () => vm.fetchReservationList()
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // 초기 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<ReservationViewModel>();
      vm.fetchReservationList();
    });
  }
}
