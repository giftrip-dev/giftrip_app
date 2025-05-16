/// 쇼핑 카테고리 열거형
enum ShoppingCategory {
  speciality, // 특산품
  local, // 로컬상품
  souvenir, // 기념품
  food, // 식품
  healthFood, // 건강식품
  livingStationery, // 생활용품/문구
  kitchen, // 주방용품
  furnitureElectronics, // 가구/가전
  medicalBeauty, // 의료/뷰티
  others; // 기타

  /// 카테고리명 반환
  String get label {
    switch (this) {
      case ShoppingCategory.speciality:
        return '특산품';
      case ShoppingCategory.local:
        return '로컬상품';
      case ShoppingCategory.souvenir:
        return '기념품';
      case ShoppingCategory.food:
        return '식품';
      case ShoppingCategory.healthFood:
        return '건강식품';
      case ShoppingCategory.livingStationery:
        return '생활용품/문구';
      case ShoppingCategory.kitchen:
        return '주방용품';
      case ShoppingCategory.furnitureElectronics:
        return '가구/가전';
      case ShoppingCategory.medicalBeauty:
        return '의료/뷰티';
      case ShoppingCategory.others:
        return '기타';
    }
  }

  /// 문자열에서 카테고리 찾기
  static ShoppingCategory? fromString(String value) {
    try {
      return ShoppingCategory.values
          .firstWhere((e) => e.toString().split('.').last == value);
    } catch (e) {
      return null;
    }
  }
}
