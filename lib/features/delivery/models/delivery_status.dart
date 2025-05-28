/// 체험 상품 카테고리
enum DeliveryStatus {
  preparing('상품 준비중'),
  shipping('배송 중'),
  completed('배송 완료');

  final String label;
  const DeliveryStatus(this.label);

  /// 문자열로부터 카테고리 생성
  static DeliveryStatus? fromString(String value) {
    try {
      return DeliveryStatus.values.firstWhere(
        (status) => status.name == value || status.label == value,
      );
    } catch (e) {
      return null;
    }
  }
}
