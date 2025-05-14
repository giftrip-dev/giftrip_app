/// 체험 상품 카테고리
enum ExperienceCategory {
  food('음식 체험'),
  craft('공예 체험'),
  play('놀이 체험'),
  space('공간 체험'),
  culture('문화예술 체험'),
  festival('축제 체험'),
  eco('생태 체험'),
  beauty('뷰티 체험'),
  wellbeing('웰빙 체험');

  final String label;
  const ExperienceCategory(this.label);

  /// 문자열로부터 카테고리 생성
  static ExperienceCategory? fromString(String value) {
    try {
      return ExperienceCategory.values.firstWhere(
        (category) => category.name == value || category.label == value,
      );
    } catch (e) {
      return null;
    }
  }
}
