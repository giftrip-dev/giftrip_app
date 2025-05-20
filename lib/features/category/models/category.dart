import 'package:giftrip/features/experience/models/experience_category.dart';

enum MainCategory {
  experience('체험'),
  product('상품'),
  lodging('숙박'),
  experienceGroup('체험단');

  final String label;
  const MainCategory(this.label);
}

class CategoryData {
  final MainCategory mainCategory;
  final List<String> subCategories;
  final Function(String)? onSubCategoryTap;

  const CategoryData({
    required this.mainCategory,
    required this.subCategories,
    this.onSubCategoryTap,
  });
}

class CategoryManager {
  static List<CategoryData> getCategoryData() {
    return [
      CategoryData(
        mainCategory: MainCategory.experience,
        subCategories: ExperienceCategory.values.map((e) => e.label).toList(),
      ),
      CategoryData(
        mainCategory: MainCategory.product,
        subCategories: [
          '여행상품',
          '특산품',
          '로컬상품',
          '기념품',
          '식품',
          '건강식품',
          '생활용품,문구',
          '주방용품',
          '가구,가전용품',
          '의류,뷰티용품',
          '기타',
        ],
      ),
      CategoryData(
        mainCategory: MainCategory.lodging,
        subCategories: [
          '호텔',
          '펜션',
          '독채',
          '모텔',
          '리조트',
          '민박',
          '캠핑/글램핑',
          '게스트하우스',
        ],
      ),
      CategoryData(
        mainCategory: MainCategory.experienceGroup,
        subCategories: [
          '인플루언서',
          '일반',
          '공동구매',
        ],
      ),
    ];
  }
}
