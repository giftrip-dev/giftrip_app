import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/app_bar/home_app_bar.dart';
import 'package:giftrip/core/widgets/product/product_item_row.dart';
import 'package:giftrip/features/order_history/models/order_booking_detail_model.dart';
import 'package:giftrip/features/order_history/repositories/order_history_repo.dart';
import 'package:giftrip/features/order_history/widgets/info_row.dart';
import 'package:intl/intl.dart';

class ProductOrderDetailScreen extends StatelessWidget {
  final String orderId;

  const ProductOrderDetailScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(title: '주문 상세'),
      body: FutureBuilder<OrderBookingDetailModel>(
        future: OrderHistoryRepo().getOrderBookingDetail(orderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('데이터를 불러오는데 실패했습니다.'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('데이터가 없습니다.'),
            );
          }

          final orderBooking = snapshot.data!;
          final formatter = NumberFormat('#,###');
          final dateFormat = DateFormat('yy.MM.dd');

          final String userName = orderBooking.reserverName;
          final String phoneNumber = orderBooking.reserverPhoneNumber;
          final int totalPrice = orderBooking.totalAmount;
          final String payMethod = orderBooking.payMethod;
          final String deliveryAddress = orderBooking.deliveryAddress ?? '';
          final String deliveryDetail = orderBooking.deliveryDetail ?? '';
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '주문 상품',
                    style: title_M,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundAlternative,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 구매 일자
                        Text(
                          dateFormat.format(orderBooking.paidAt),
                          style: subtitle_L,
                        ),
                        const SizedBox(height: 16),
                        // 상품 리스트
                        ...orderBooking.items.asMap().entries.map((entry) {
                          final item = entry.value;
                          final isLast =
                              entry.key == orderBooking.items.length - 1;
                          return Column(
                            children: [
                              ProductItemRow(
                                thumbnailUrl: item.thumbnailUrl,
                                title: item.title,
                                quantity: item.quantity,
                                price: item.totalPrice,
                                type: item.category,
                              ),
                              if (!isLast) const SizedBox(height: 16),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 주문자 정보
                  const Text(
                    '주문자 정보',
                    style: title_M,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundAlternative,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        InfoRow(
                          label: '이름',
                          value: userName,
                        ),
                        const SizedBox(height: 12),
                        InfoRow(
                          label: '휴대폰 번호',
                          value: phoneNumber,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 배송 정보
                  const Text(
                    '배송지 정보',
                    style: title_M,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundAlternative,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        InfoRow(
                          label: '기본 배송지',
                          value: deliveryAddress,
                        ),
                        const SizedBox(height: 12),
                        InfoRow(
                          label: '상세 정보',
                          value: deliveryDetail,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 결제 금액
                  const Text(
                    '결제 금액',
                    style: title_M,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundAlternative,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // 개별 상품 가격들
                        ...orderBooking.items
                            .map((item) => Column(
                                  children: [
                                    InfoRow(
                                      label: '${item.title}, ${item.quantity}개',
                                      value:
                                          '${formatter.format(item.totalPrice)}원',
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                ))
                            .toList(),
                        const Divider(height: 1, color: AppColors.line),
                        const SizedBox(height: 12),
                        InfoRow(
                          label: '총 결제 금액',
                          value: '${formatter.format(totalPrice)}원',
                        ),
                        const SizedBox(height: 12),
                        InfoRow(
                          label: '결제수단',
                          value: payMethod,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
