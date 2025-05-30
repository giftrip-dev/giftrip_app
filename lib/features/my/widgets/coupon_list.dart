import 'package:flutter/material.dart';
import 'package:giftrip/features/my/models/coupon_model.dart';
import 'coupon_item.dart';

class CouponList extends StatelessWidget {
  final List<CouponModel> coupons;
  const CouponList({super.key, required this.coupons});

  @override
  Widget build(BuildContext context) {
    if (coupons.isEmpty) {
      return const Center(child: Text('사용 가능한 쿠폰이 없습니다.'));
    }
    return Column(
      children: coupons.map((coupon) => CouponItem(coupon: coupon)).toList(),
    );
  }
}
