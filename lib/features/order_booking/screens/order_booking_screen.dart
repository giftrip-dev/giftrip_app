import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/app_bar/search_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/features/order_booking/view_models/order_booking_view_model.dart';
import 'package:giftrip/features/order_booking/widgets/persistent_category_bar.dart';
import 'package:giftrip/features/order_booking/widgets/order_booking_list.dart';
import 'package:giftrip/features/order_booking/repositories/mock_order_booking_data.dart';

class OrderBookingScreen extends StatefulWidget {
  const OrderBookingScreen({super.key});

  @override
  _OrderBookingScreenState createState() => _OrderBookingScreenState();
}

class _OrderBookingScreenState extends State<OrderBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchAppBar(title: '주문/예약'),
      body: Consumer<OrderBookingViewModel>(
        builder: (context, vm, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await vm.fetchOrderBookingList(refresh: true);
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
              body: OrderBookingList(
                orderBookings: vm.orderBookingList,
                isLoading: vm.isLoading,
                hasError: vm.hasError,
                onLoadMore: vm.nextPage != null
                    ? () => vm.fetchOrderBookingList()
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
      final vm = context.read<OrderBookingViewModel>();
      vm.fetchOrderBookingList();
    });
  }
}
