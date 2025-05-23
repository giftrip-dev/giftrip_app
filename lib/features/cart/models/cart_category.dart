import 'package:giftrip/core/widgets/category/category_interface.dart';
import 'package:giftrip/features/category/models/category.dart';

/// 장바구니 카테고리
enum CartCategory implements CategoryInterface {
  lodging('숙박'),
  experience('체험'),
  experienceGroup('체험단'),
  product('상품');

  @override
  final String label;
  const CartCategory(this.label);

  /// MainCategory로 변환
  MainCategory get mainCategory {
    switch (this) {
      case CartCategory.experience:
        return MainCategory.experience;
      case CartCategory.product:
        return MainCategory.product;
      case CartCategory.lodging:
        return MainCategory.lodging;
      case CartCategory.experienceGroup:
        return MainCategory.experienceGroup;
    }
  }

  /// 문자열로부터 카테고리 생성
  static CartCategory? fromString(String value) {
    try {
      return CartCategory.values.firstWhere(
        (category) => category.name == value || category.label == value,
      );
    } catch (e) {
      return null;
    }
  }
}
