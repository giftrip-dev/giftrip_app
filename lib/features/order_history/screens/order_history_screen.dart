import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/app_bar/search_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/features/order_history/view_models/order_history_view_model.dart';
import 'package:giftrip/features/order_history/widgets/persistent_category_bar.dart';
import 'package:giftrip/features/order_history/widgets/order_history_list.dart';
import 'package:giftrip/features/order_history/repositories/mock_order_booking_data.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchAppBar(title: '주문/예약'),
      body: Consumer<OrderHistoryViewModel>(
        builder: (context, vm, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await vm.fetchOrderHistoryList(refresh: true);
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
                      totalCount: mockOrderBookingList.length,
                    ),
                  ),
                ];
              },
              // 카테고리 바와 리스트 사이 간격
              body: OrderHistoryList(
                orderBookings: vm.orderBookingList,
                isLoading: vm.isLoading,
                hasError: vm.hasError,
                onLoadMore: vm.nextPage != null
                    ? () => vm.fetchOrderHistoryList()
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
      final vm = context.read<OrderHistoryViewModel>();
      vm.fetchOrderHistoryList();
    });
  }
}
