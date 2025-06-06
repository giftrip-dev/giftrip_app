import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/core/widgets/image/custom_image.dart';
import 'package:giftrip/core/widgets/text/price_text.dart';
import 'package:giftrip/features/order_history/models/order_history_model.dart';
import 'package:giftrip/features/order_history/screens/booking_order_detail_screen.dart';
import 'package:giftrip/features/order_history/screens/product_order_detail_screen.dart';
import 'package:giftrip/features/order_history/widgets/payment_cancel_button.dart';
import 'package:intl/intl.dart';

class OrderHistoryListItem extends StatelessWidget {
  final OrderHistoryModel orderBooking;

  const OrderHistoryListItem({
    super.key,
    required this.orderBooking,
  });

  bool get isProduct =>
      orderBooking.items.first.category == ProductItemType.product;

  Widget _buildProductItem(OrderHistoryItemModel item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 상품 썸네일
        CustomImage(
          imageUrl: item.thumbnailUrl,
          width: 60,
          height: 60,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(width: 12),
        // 상품 정보
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.category == ProductItemType.product
                    ? '${item.title}, ${item.quantity}개'
                    : item.title,
                style: body_S,
              ),
              const SizedBox(height: 4),
              PriceText(
                price: item.totalPrice,
                color: AppColors.labelStrong,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    // 취소된 상태일 때는 모든 카테고리에서 취소완료 버튼 표시
    if (orderBooking.progress == OrderBookingProgress.canceled) {
      return CTAButton(
        isEnabled: false,
        onPressed: null,
        type: CTAButtonType.outline,
        size: CTAButtonSize.medium,
        text: '취소 완료',
        textStyle: title_S.copyWith(color: AppColors.labelAlternative),
      );
    }

    if (isProduct) {
      if (orderBooking.progress == OrderBookingProgress.confirmed) {
        return Row(
          children: [
            Expanded(
              child: CTAButton(
                isEnabled: true,
                onPressed: () {},
                type: CTAButtonType.outline,
                size: CTAButtonSize.medium,
                text: '배송지 변경',
                textStyle: title_S.copyWith(color: AppColors.labelStrong),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PaymentCancelButton(orderBooking: orderBooking),
            ),
          ],
        );
      } else if (orderBooking.progress == OrderBookingProgress.completed) {
        return Row(
          children: [
            Expanded(
              child: CTAButton(
                isEnabled: true,
                onPressed: () {},
                type: CTAButtonType.outline,
                size: CTAButtonSize.medium,
                text: '배송지 변경',
                textStyle: title_S.copyWith(color: AppColors.labelStrong),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PaymentCancelButton(orderBooking: orderBooking),
            ),
          ],
        );
      }
    } else {
      if (orderBooking.progress == OrderBookingProgress.confirmed) {
        return PaymentCancelButton(orderBooking: orderBooking);
      }
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yy.MM.dd');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단: 구매날짜, 상세보기
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateFormat.format(orderBooking.paidAt),
                style: subtitle_L.copyWith(
                  color: AppColors.labelStrong,
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (orderBooking.items.first.category ==
                      ProductItemType.product) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductOrderDetailScreen(
                          orderId: orderBooking.id,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingOrderDetailScreen(
                          bookingId: orderBooking.id,
                        ),
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    Text(
                      '상세보기',
                      style: body_S.copyWith(
                        color: AppColors.labelStrong,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: AppColors.labelStrong,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 구매 아이템들 (24px 간격으로 세로 나열)
          Column(
            children: orderBooking.items
                .map((item) => Padding(
                      padding: EdgeInsets.only(
                        bottom: item == orderBooking.items.last ? 0 : 24,
                      ),
                      child: _buildProductItem(item),
                    ))
                .toList(),
          ),

          const SizedBox(height: 24),
          // 하단 버튼
          SizedBox(
            width: double.infinity,
            child: _buildButtons(context),
          ),
        ],
      ),
    );
  }
}
