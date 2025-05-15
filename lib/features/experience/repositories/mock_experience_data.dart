import 'package:myong/features/experience/models/experience_category.dart';
import 'package:myong/features/experience/models/experience_model.dart';
import 'package:myong/features/home/models/product_model.dart';

/// 목업 체험 상품 데이터
final List<ExperienceModel> mockExperienceList = List.generate(
  50,
  (index) {
    // 카테고리를 순환하면서 할당
    final categoryIndex = index % ExperienceCategory.values.length;
    final category = ExperienceCategory.values[categoryIndex];

    // 5개 중 2개는 할인 적용 (0~50% 할인)
    final hasDiscount = index % 5 < 2;
    final originalPrice = 10000 + (index * 1000); // 10,000원부터 1,000원씩 증가
    final discountRate = hasDiscount ? ((index % 5 + 1) * 10) : null;
    final finalPrice = discountRate != null
        ? (originalPrice * (100 - discountRate) ~/ 100)
        : originalPrice;

    // 뱃지 설정
    final badges = <ProductTagType>[];

    // 첫 10개 상품은 NEW 뱃지
    if (index < 10) {
      badges.add(ProductTagType.newArrival);
    }

    // 인덱스가 3의 배수인 상품은 BEST 뱃지
    if (index % 3 == 0) {
      badges.add(ProductTagType.bestSeller);
    }

    // 인덱스가 7의 배수인 상품은 품절임박 뱃지
    if (index % 7 == 0) {
      badges.add(ProductTagType.almostSoldOut);
    }

    // 구매 가능 기간 설정 (현재로부터 1일 후 ~ 60일 후까지)
    final now = DateTime.now();
    final availableFrom = now.add(Duration(days: 1 + (index % 5))); // 1-5일 후부터
    final availableTo =
        now.add(Duration(days: 30 + (index % 30))); // 30-59일 후까지

    return ExperienceModel(
      id: 'exp_${index + 1}',
      title: '${category.label} 상품 ${index + 1}',
      description:
          '이것은 ${category.label} 상품 ${index + 1}의 상세 설명입니다. 특별한 체험을 통해 잊지 못할 추억을 만들어보세요.',
      thumbnailUrl: 'assets/png/banner.png',
      originalPrice: originalPrice,
      finalPrice: finalPrice,
      category: category,
      rating: 3.5 + (index % 20) / 10, // 3.5 ~ 5.0 사이의 평점
      reviewCount: 10 + index, // 10개부터 1개씩 증가
      discountRate: discountRate,
      badges: badges,
      availableFrom: availableFrom,
      availableTo: availableTo,
    );
  },
);
