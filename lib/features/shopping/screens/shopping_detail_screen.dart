import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/features/shopping/view_models/shopping_view_model.dart';

class ShoppingDetailScreen extends StatefulWidget {
  final String shoppingId;

  const ShoppingDetailScreen({
    super.key,
    required this.shoppingId,
  });

  @override
  _ShoppingDetailScreenState createState() => _ShoppingDetailScreenState();
}

class _ShoppingDetailScreenState extends State<ShoppingDetailScreen> {
  @override
  void initState() {
    super.initState();
    // 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShoppingViewModel>().fetchShoppingDetail(widget.shoppingId);
    });
  }

  @override
  void dispose() {
    // 선택된 상품 초기화
    context.read<ShoppingViewModel>().clearSelectedShopping();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상품 상세'),
      ),
      body: Consumer<ShoppingViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.hasError) {
            return const Center(child: Text('데이터를 불러오는데 실패했습니다.'));
          }

          final shopping = vm.selectedShopping;
          if (shopping == null) {
            return const Center(child: Text('상품을 찾을 수 없습니다.'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상품 상세 정보 표시 (나중에 구현)
                Text('상품명: ${shopping.title}'),
                Text('제조사: ${shopping.manufacturer}'),
                Text('가격: ${shopping.finalPrice}원'),
                Text('배송 정보: ${shopping.deliveryInfo}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
