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
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
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
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/png/logo.png', width: 48),
                const SizedBox(height: 12),
                Text(
                  coupon.couponName,
                  style: body_M.copyWith(color: AppColors.label),
                ),
                const SizedBox(height: 4),
                Text(
                  '${coupon.category.label} ${coupon.discountRate}% 할인',
                  style: h1_R.copyWith(color: AppColors.labelStrong),
                ),
              ],
            ),
            const Spacer(),
            // 날짜
            Container(
              padding: const EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: AppColors.line,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    dateFormat.format(DateTime.parse(coupon.startDate)),
                    style: caption.copyWith(color: AppColors.labelAlternative),
                  ),
                  Text('~',
                      style:
                          body_S.copyWith(color: AppColors.labelAlternative)),
                  Text(
                    dateFormat.format(DateTime.parse(coupon.endDate)),
                    style: caption.copyWith(color: AppColors.labelAlternative),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
