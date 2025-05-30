import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:giftrip/features/my/screens/user_management_screen.dart';
import 'package:giftrip/features/my/screens/coupon_screen.dart';

class MyInfoBox extends StatelessWidget {
  final bool isInfluencer;
  final String nickname;
  final int point;
  final int couponCount;

  const MyInfoBox({
    Key? key,
    required this.isInfluencer,
    required this.nickname,
    required this.point,
    required this.couponCount,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final formattedPoint = NumberFormat('#,###').format(point);
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryAlternative,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isInfluencer)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.statusClear,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '인플루언서',
                style: subtitle_XS.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          if (isInfluencer) const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserManagementScreen(),
                ),
              );
            },
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      nickname,
                      style: subtitle_L.copyWith(color: AppColors.labelStrong),
                    ),
                    Text(
                      '님 안녕하세요',
                      style: body_L.copyWith(color: AppColors.label),
                    ),
                  ],
                ),
                const Icon(
                  LucideIcons.chevronRight,
                  color: AppColors.component,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          // divider
          const Divider(
            color: AppColors.primary,
            height: 1,
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {},
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '나의 포인트',
                        style: body_M.copyWith(color: AppColors.label),
                      ),
                      Row(
                        children: [
                          Text(
                            '$formattedPoint P',
                            style: body_M.copyWith(color: AppColors.label),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            LucideIcons.chevronRight,
                            color: AppColors.component,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CouponScreen(),
                    ),
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '쿠폰함',
                        style: body_M.copyWith(color: AppColors.label),
                      ),
                      Row(
                        children: [
                          Text(
                            '$couponCount개',
                            style: body_M.copyWith(color: AppColors.label),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            LucideIcons.chevronRight,
                            color: AppColors.component,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
