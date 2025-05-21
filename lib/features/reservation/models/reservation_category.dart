/// 체험 상품 카테고리
enum ReservationCategory {
  lodging('숙박'),
  experience('체험'),
  product('상품'),
  experienceGroup('체험단');

  final String label;
  const ReservationCategory(this.label);

  /// 문자열로부터 카테고리 생성
  static ReservationCategory? fromString(String value) {
    try {
      return ReservationCategory.values.firstWhere(
        (category) => category.name == value || category.label == value,
      );
    } catch (e) {
      return null;
    }
  }
}
