enum CategoryType {
  product('상품'),
  lodging('숙소'),
  experience('체험'),
  all('전체');

  final String label;
  const CategoryType(this.label);
}

class CouponModel {
  final String id; // 예약 고유 ID
  final String couponName;
  final String startDate; // 예약일자 (예: 24.08.23)
  final String endDate; // 예약일자 (예: 24.08.23)
  final CategoryType category; // 카테고리
  final int discount; // 할인 금액
  final int discountRate; // 할인 비율
  final int discountMax; // 할인 최대 금액
  final int discountMin; // 할인 최소 금액

  const CouponModel({
    required this.id,
    required this.couponName,
    required this.startDate,
    required this.endDate,
    required this.category,
    required this.discount,
    required this.discountRate,
    required this.discountMax,
    required this.discountMin,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'] as String,
      couponName: json['couponName'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      category: json['category'] as CategoryType,
      discount: json['discount'] as int,
      discountRate: json['discountRate'] as int,
      discountMax: json['discountMax'] as int,
      discountMin: json['discountMin'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'couponName': couponName,
      'startDate': startDate,
      'endDate': endDate,
      'discount': discount,
      'discountRate': discountRate,
      'discountMax': discountMax,
      'discountMin': discountMin,
      'category': category,
    };
  }

  CouponModel copyWith({
    String? id,
    String? couponName,
    String? startDate,
    String? endDate,
    CategoryType? category,
    int? discount,
    int? discountRate,
    int? discountMax,
    int? discountMin,
  }) {
    return CouponModel(
        id: id ?? this.id,
        couponName: couponName ?? this.couponName,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        discount: discount ?? this.discount,
        discountRate: discountRate ?? this.discountRate,
        discountMax: discountMax ?? this.discountMax,
        discountMin: discountMin ?? this.discountMin,
        category: category ?? this.category);
  }
}
