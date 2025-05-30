import 'package:giftrip/features/my/models/coupon_model.dart';

/// 목업 데이터
final List<CouponModel> mockCouponList = [
  CouponModel(
    id: '1',
    couponName: '기프트립 신규회원 웰컴 쿠폰',
    startDate: DateTime.now().subtract(const Duration(days: 0)).toString(),
    endDate: DateTime.now().add(const Duration(days: 15)).toString(),
    discount: 30000,
    discountRate: 10,
    discountMax: 30000,
    discountMin: 10000,
    category: CategoryType.lodging,
  ),
  CouponModel(
    id: '2',
    couponName: '기프트립 신규회원 웰컴 쿠폰',
    startDate: DateTime.now().subtract(const Duration(days: 0)).toString(),
    endDate: DateTime.now().add(const Duration(days: 15)).toString(),
    discount: 20000,
    discountRate: 20,
    discountMax: 30000,
    discountMin: 10000,
    category: CategoryType.experience,
  ),
  CouponModel(
    id: '3',
    couponName: '기프트립 신규회원 웰컴 쿠폰',
    startDate: DateTime.now().subtract(const Duration(days: 0)).toString(),
    endDate: DateTime.now().add(const Duration(days: 15)).toString(),
    discount: 30000,
    discountRate: 30,
    discountMax: 30000,
    discountMin: 10000,
    category: CategoryType.product,
  ),
];
