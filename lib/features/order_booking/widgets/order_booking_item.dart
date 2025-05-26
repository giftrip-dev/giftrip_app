import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/features/order_booking/models/order_booking_model.dart';
import 'package:giftrip/features/order_booking/models/order_booking_category.dart';
import 'package:giftrip/features/order_booking/screens/booking_detail_screen.dart';
import 'package:giftrip/features/order_booking/screens/order_detail_screen.dart';
import 'package:giftrip/core/widgets/modal/two_button_modal.dart';
import 'package:giftrip/features/order_booking/view_models/order_booking_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrderBookingItem extends StatelessWidget {
  final OrderBookingModel orderBooking;

  const OrderBookingItem({
    super.key,
    required this.orderBooking,
  });

  bool get isProduct => orderBooking.category == OrderBookingCategory.product;

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
              child: CTAButton(
                isEnabled: true,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => TwoButtonModal(
                      title: '구매를 취소하시나요?',
                      desc:
                          '${orderBooking.title} 구매를 취소하시나요? \n취소 후에는 복구할 수 없습니다.',
                      cancelText: '닫기',
                      confirmText: '구매 취소',
                      onConfirm: () => context
                          .read<OrderBookingViewModel>()
                          .handleCancel(context, orderBooking),
                    ),
                  );
                },
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
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => TwoButtonModal(
                title: '예약을 취소하시나요?',
                desc: '${orderBooking.title} 예약을 취소하시나요? \n취소 후에는 복구할 수 없습니다.',
                cancelText: '닫기',
                confirmText: '예약 취소',
                onConfirm: () => context
                    .read<OrderBookingViewModel>()
                    .handleCancel(context, orderBooking),
              ),
            );
          },
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
                          orderId: orderBooking.id,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingDetailScreen(
                          bookingId: orderBooking.id,
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
            child: _buildButtons(context),
          ),
        ],
      ),
    );
  }
}
