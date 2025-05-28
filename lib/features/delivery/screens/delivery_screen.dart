import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/app_bar/home_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/features/delivery/view_models/delivery_view_model.dart';
import 'package:giftrip/features/delivery/widgets/delivery_list.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(title: '배송 목록'),
      body: Consumer<DeliveryViewModel>(
        builder: (context, vm, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await vm.fetchDeliveryList(refresh: true);
            },
            color: AppColors.primary,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              child: DeliveryList(
                deliveries: vm.deliveryList,
                isLoading: vm.isLoading,
                hasError: vm.hasError,
                onLoadMore:
                    vm.nextPage != null ? () => vm.fetchDeliveryList() : null,
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
      final vm = context.read<DeliveryViewModel>();
      vm.fetchDeliveryList();
    });
  }
}
