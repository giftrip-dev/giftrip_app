import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/app_bar/home_app_bar.dart';
import 'package:giftrip/features/order_booking/models/order_booking_detail_model.dart';
import 'package:giftrip/features/order_booking/repositories/order_booking_repo.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(title: '주문 상세'),
      body: FutureBuilder<OrderBookingDetailModel>(
        future: OrderBookingRepo().getOrderBookingDetail(orderId),
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
          final dateFormat = DateFormat('yyyy.MM.dd');

          // 예약자 정보
          final String userName = orderBooking.reserverName;
          final String phoneNumber = orderBooking.reserverPhoneNumber;
          final int productPrice = orderBooking.finalPrice;
          final int totalPrice = orderBooking.finalPrice;
          final String payMethod = orderBooking.payMethod;
          final String deliveryAddress = orderBooking.deliveryAddress ?? '';
          final String deliveryDetail = orderBooking.deliveryDetail ?? '';
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 주문 상품
                  const Text('주문 상품', style: title_M),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundAlternative,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            orderBooking.thumbnailUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dateFormat.format(orderBooking.paidAt),
                                style: caption.copyWith(
                                    color: AppColors.labelAlternative),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                orderBooking.title,
                                style: body_M.copyWith(
                                  color: AppColors.labelStrong,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${formatter.format(orderBooking.finalPrice)}원',
                                style: title_M.copyWith(
                                  color: AppColors.labelStrong,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 예약자 정보
                  const Text(
                    '예약자 정보',
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('이름', style: body_S),
                            Text(userName, style: subtitle_S),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('휴대폰 번호', style: body_S),
                            Text(phoneNumber, style: subtitle_S),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 배송 정보
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('기본 배송지', style: body_S),
                            Text(deliveryAddress, style: subtitle_S),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('상세 정보', style: body_S),
                            Text(deliveryDetail, style: subtitle_S),
                          ],
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('상품 금액', style: body_S),
                            Text('${formatter.format(productPrice)}원',
                                style: subtitle_S),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1, color: AppColors.line),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('총 결제 금액', style: body_S),
                            Text('${formatter.format(totalPrice)}원',
                                style: subtitle_S),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('결제수단', style: body_S),
                            Text(payMethod, style: subtitle_S),
                          ],
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
