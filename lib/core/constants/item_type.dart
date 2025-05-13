/// 상품 타입 정의
enum ProductItemType {
  /// 일반 쇼핑 상품
  product('product', '쇼핑'),

  /// 숙소 상품
  accommodation('accommodation', '숙소'),

  /// 체험 상품
  experience('experience', '체험'),

  /// 체험단 상품
  experienceGroup('experience_group', '체험단');

  final String value;
  final String label;

  const ProductItemType(this.value, this.label);

  /// String 값으로부터 ItemType을 찾아서 반환
  static ProductItemType? fromString(String value) {
    return ProductItemType.values.firstWhere(
      (type) => type.value == value.toLowerCase(),
      orElse: () => ProductItemType.product,
    );
  }

  /// 서버 API 요청시 사용할 값 반환
  String toJson() => value;

  @override
  String toString() => label;
}
