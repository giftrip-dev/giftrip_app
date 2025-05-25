import 'package:giftrip/core/widgets/category/category_interface.dart';

/// 체험단 카테고리
enum TesterCategory implements CategoryInterface {
  influencer('인플루언서'),
  general('일반'),
  groupBuy('공동구매');

  @override
  final String label;
  const TesterCategory(this.label);

  /// 문자열로부터 카테고리 생성
  static TesterCategory? fromString(String value) {
    try {
      return TesterCategory.values.firstWhere(
        (category) => category.name == value || category.label == value,
      );
    } catch (e) {
      return null;
    }
  }
}
