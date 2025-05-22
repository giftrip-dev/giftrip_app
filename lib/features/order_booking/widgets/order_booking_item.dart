import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/features/order_booking/models/order_booking_model.dart';
import 'package:giftrip/features/order_booking/models/order_booking_category.dart';
import 'package:giftrip/features/order_booking/screens/booking_detail_screen.dart';
import 'package:giftrip/features/order_booking/screens/order_detail_screen.dart';
import 'package:intl/intl.dart';

class OrderBookingItem extends StatelessWidget {
  final OrderBookingModel orderBooking;

  const OrderBookingItem({
    super.key,
    required this.orderBooking,
  });

  bool get isProduct => orderBooking.category == OrderBookingCategory.product;

  Widget _buildButtons() {
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
              child: CTAButton(
                isEnabled: true,
                onPressed: () {},
                type: CTAButtonType.outline,
                size: CTAButtonSize.medium,
                text: '구매 취소',
                textStyle: title_S.copyWith(color: AppColors.labelStrong),
              ),
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
                text: '리뷰 작성',
                textStyle: title_S.copyWith(color: AppColors.labelStrong),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CTAButton(
                isEnabled: true,
                onPressed: () {},
                type: CTAButtonType.outline,
                size: CTAButtonSize.medium,
                text: '배송 조회',
                textStyle: title_S.copyWith(color: AppColors.labelStrong),
              ),
            ),
          ],
        );
      }
    } else {
      if (orderBooking.progress == OrderBookingProgress.confirmed) {
        return CTAButton(
          isEnabled: true,
          onPressed: () {},
          type: CTAButtonType.outline,
          size: CTAButtonSize.medium,
          text: '예약 취소',
          textStyle: title_S.copyWith(color: AppColors.labelStrong),
        );
      } else if (orderBooking.progress == OrderBookingProgress.completed) {
        return CTAButton(
          isEnabled: true,
          onPressed: () {},
          type: CTAButtonType.outline,
          size: CTAButtonSize.medium,
          text: '리뷰 작성',
          textStyle: title_S.copyWith(color: AppColors.labelStrong),
        );
      }
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    final dateFormat = DateFormat('yyyy.MM.dd');

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단: 카테고리, 상세보기
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                orderBooking.category.label,
                style: heading_4.copyWith(
                  color: AppColors.primaryStrong,
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (orderBooking.category == OrderBookingCategory.product) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailScreen(
                          orderBooking: orderBooking,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingDetailScreen(
                          orderBooking: orderBooking,
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  '상세보기',
                  style: body_S.copyWith(
                    color: AppColors.labelAlternative,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 본문: 이미지 + 정보
          Row(
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
                        color: AppColors.labelAlternative,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      orderBooking.title,
                      style: body_M.copyWith(
                        color: AppColors.labelStrong,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
          const SizedBox(height: 16),
          // 하단 버튼
          SizedBox(
            width: double.infinity,
            child: _buildButtons(),
          ),
        ],
      ),
    );
  }
}
