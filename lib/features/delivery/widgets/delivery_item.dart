import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/features/delivery/models/delivery_model.dart';
import 'package:giftrip/features/delivery/models/delivery_status.dart';
import 'package:giftrip/features/order_booking/screens/order_detail_screen.dart';
import 'package:giftrip/features/order_booking/screens/booking_detail_screen.dart';
import 'package:giftrip/features/delivery/view_models/delivery_view_model.dart';
import 'package:giftrip/core/widgets/modal/two_button_modal.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

class DeliveryItem extends StatelessWidget {
  final DeliveryModel delivery;

  const DeliveryItem({
    super.key,
    required this.delivery,
  });

  bool get isProduct => delivery.status == DeliveryStatus.preparing;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    final dateFormat = DateFormat('yy.MM.dd');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단: 날짜, 상태 뱃지
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateFormat.format(delivery.paidAt),
                style: title_L.copyWith(
                  color: AppColors.labelStrong,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF2659CC).withValues(alpha: 0.21),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  delivery.status.label,
                  style: subtitle_XS.copyWith(
                    color: AppColors.gray900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 본문: 이미지 + 정보
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  delivery.thumbnailUrl,
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
                      delivery.title,
                      style: body_M.copyWith(
                        color: AppColors.labelStrong,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${delivery.option}, ${delivery.quantity}개',
                      style: body_M.copyWith(
                        color: AppColors.labelStrong,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${formatter.format(delivery.finalPrice)}원',
                      style: title_M.copyWith(
                        color: AppColors.labelStrong,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 하단 버튼
          SizedBox(
            width: double.infinity,
            child: CTAButton(
              isEnabled: true,
              onPressed: () {
                if (delivery.status == DeliveryStatus.preparing) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailScreen(
                        orderId: delivery.id,
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BookingDetailScreen(bookingId: delivery.id),
                    ),
                  );
                }
              },
              type: CTAButtonType.outline,
              size: CTAButtonSize.medium,
              text: '배송 상세보기',
              textStyle: title_S.copyWith(color: AppColors.labelStrong),
            ),
          ),
        ],
      ),
    );
  }
}
