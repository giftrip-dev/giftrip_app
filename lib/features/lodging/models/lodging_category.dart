/// 숙소 상품 카테고리
enum LodgingCategory {
  hotel('호텔'),
  pension('펜션'),
  privateHouse('독채'),
  motel('모텔'),
  resort('리조트'),
  inn('민박'),
  camping('캠핑/글램핑'),
  guestHouse('게스트하우스');

  final String label;
  const LodgingCategory(this.label);

  /// 기본 선택 카테고리
  static LodgingCategory get defaultCategory => LodgingCategory.hotel;

  /// 문자열로부터 카테고리 생성
  static LodgingCategory? fromString(String value) {
    try {
      return LodgingCategory.values.firstWhere(
        (category) => category.name == value || category.label == value,
      );
    } catch (e) {
      return null;
    }
  }
}
