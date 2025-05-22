/// 체험 상품 카테고리
enum OrderBookingCategory {
  lodging('숙박'),
  experience('체험'),
  product('상품'),
  experienceGroup('체험단');

  final String label;
  const OrderBookingCategory(this.label);

  /// 문자열로부터 카테고리 생성
  static OrderBookingCategory? fromString(String value) {
    try {
      return OrderBookingCategory.values.firstWhere(
        (category) => category.name == value || category.label == value,
      );
    } catch (e) {
      return null;
    }
  }
}
