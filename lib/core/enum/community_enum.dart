// 미용 카테고리
enum BeautyCategory {
  hair,
  makeup,
  nail,
  skinEsthetic, // JSON에서 "SKIN_ESTHETIC"을 처리하기 위해 카멜케이스 사용
  free;

  // 문자열 → Enum
  static BeautyCategory fromString(String category) {
    switch (category.toUpperCase()) {
      case 'HAIR':
        return BeautyCategory.hair;
      case 'MAKEUP':
        return BeautyCategory.makeup;
      case 'NAIL':
        return BeautyCategory.nail;
      case 'SKIN_ESTHETIC':
        return BeautyCategory.skinEsthetic;
      case 'FREE':
        return BeautyCategory.free;
      default:
        throw ArgumentError('Unknown beauty category: $category');
    }
  }

  // Enum -> 서비스 문자 변환
  static String toKoreanString(BeautyCategory category) {
    switch (category) {
      case BeautyCategory.hair:
        return '헤어';
      case BeautyCategory.makeup:
        return '메이크업';
      case BeautyCategory.nail:
        return '네일';
      case BeautyCategory.skinEsthetic:
        return '피부';
      case BeautyCategory.free:
        return '자유';
    }
  }

  // Enum → 문자열 변환
  static String toUpperString(BeautyCategory category) {
    switch (category) {
      case BeautyCategory.hair:
        return 'HAIR';
      case BeautyCategory.makeup:
        return 'MAKEUP';
      case BeautyCategory.nail:
        return 'NAIL';
      case BeautyCategory.skinEsthetic:
        return 'SKIN_ESTHETIC';
      case BeautyCategory.free:
        return 'FREE';
    }
  }

  // 한국어 -> Enum
  static BeautyCategory toEnglishString(String category) {
    switch (category) {
      case '헤어':
        return BeautyCategory.hair;
      case '메이크업':
        return BeautyCategory.makeup;
      case '네일':
        return BeautyCategory.nail;
      case '피부':
        return BeautyCategory.skinEsthetic;
      default:
        throw ArgumentError('Unknown category: $category');
    }
  }
}

enum PostSortType {
  latest, // 최신순
  popular, // 인기순
  comments; // 댓글순

  // enum -> 문자열
  String toUpperString() {
    switch (this) {
      case PostSortType.latest:
        return 'LATEST';
      case PostSortType.popular:
        return 'POPULAR';
      case PostSortType.comments:
        return 'COMMENTS';
    }
  }

  // 문자열 -> enum
  static PostSortType fromString(String sort) {
    switch (sort.toUpperCase()) {
      case 'LATEST':
        return PostSortType.latest;
      case 'POPULAR':
        return PostSortType.popular;
      case 'COMMENTS':
        return PostSortType.comments;
      default:
        throw ArgumentError('Unknown PostSortType: $sort');
    }
  }
}
