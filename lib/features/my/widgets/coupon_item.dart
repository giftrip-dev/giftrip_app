import 'package:flutter/material.dart';
import 'package:giftrip/features/my/models/coupon_model.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:intl/intl.dart';

class CouponItem extends StatelessWidget {
  final CouponModel coupon;
  const CouponItem({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yy.MM.dd');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1F000000), // #00000012 (12% opacity)
            offset: const Offset(0, 6),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // giftrip 로고 및 텍스트
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('gif',
                        style: title_L.copyWith(color: AppColors.primary)),
                    Text('trip',
                        style: title_L.copyWith(color: AppColors.labelStrong)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  coupon.couponName,
                  style: body_M.copyWith(color: AppColors.label),
                ),
                const SizedBox(height: 12),
                Text(
                  coupon.discountRate > 0
                      ? '숙박 ${coupon.discountRate}% 할인'
                      : '숙박 ${NumberFormat('#,###').format(coupon.discount)}원 할인',
                  style: title_L.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Spacer(),
            // 날짜
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  dateFormat.format(DateTime.parse(coupon.startDate)),
                  style: body_S.copyWith(color: AppColors.labelAlternative),
                ),
                const Text('~', style: body_S),
                Text(
                  dateFormat.format(DateTime.parse(coupon.endDate)),
                  style: body_S.copyWith(color: AppColors.labelAlternative),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
