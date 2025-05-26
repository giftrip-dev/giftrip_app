import 'package:giftrip/features/experience/models/experience_category.dart';
import 'package:giftrip/features/experience/models/experience_model.dart';
import 'package:giftrip/features/home/models/product_model.dart';
import 'package:giftrip/features/home/view_models/product_view_model.dart';

/// 목업 체험 상품 데이터
/// 홈스크린의 목업 데이터에서 체험 타입만 필터링해서 ExperienceModel로 변환
final List<ExperienceModel> mockExperienceList = () {
  // 홈스크린 목업 데이터에서 체험 타입만 필터링
  final experienceProducts = mockProducts
      .where((product) => product.productType == ProductType.experience)
      .toList();

  // ProductModel을 ExperienceModel로 변환
  return experienceProducts.map((product) {
    // ID에서 인덱스 추출 (exp_1 -> 0, exp_2 -> 1, ...)
    final index = int.parse(product.id.split('_')[1]) - 1;

    // 카테고리를 순환하면서 할당
    final categoryIndex = index % ExperienceCategory.values.length;
    final category = ExperienceCategory.values[categoryIndex];

    // 구매 가능 기간 설정 (현재로부터 1일 후 ~ 60일 후까지)
    final now = DateTime.now();
    final availableFrom = now.add(Duration(days: 1 + (index % 5))); // 1-5일 후부터
    final availableTo =
        now.add(Duration(days: 30 + (index % 30))); // 30-59일 후까지

    // 품절 여부 (6번째마다 하나씩 품절)
    final soldOut = index % 6 == 0;

    // 이용 불가능 날짜 생성 (랜덤으로 3~7일)
    final unavailableDates = <String>[];
    if (!soldOut) {
      // 품절이 아닌 상품만 불가능 날짜 설정
      final random = index % 5 + 3; // 3~7일
      final startDay = 5 + (index % 10); // 5~14일 후부터

      for (var i = 0; i < random; i++) {
        final unavailableDate = now.add(Duration(days: startDay + i * 2));
        unavailableDates.add(unavailableDate.toIso8601String().split('T')[0]);
      }
    }

    return ExperienceModel(
      id: product.id, // 홈스크린과 동일한 ID 사용
      title: '${category.label} 상품 ${index + 1}',
      description:
          '이것은 ${category.label} 상품 ${index + 1}의 상세 설명입니다. 특별한 체험을 통해 잊지 못할 추억을 만들어보세요.',
      thumbnailUrl: product.thumbnailUrl,
      originalPrice: product.originalPrice,
      finalPrice: product.finalPrice,
      category: category,
      rating: 3.5 + (index % 20) / 10, // 3.5 ~ 5.0 사이의 평점
      reviewCount: 10 + index, // 10개부터 1개씩 증가
      discountRate: product.discountRate,
      badges: product.badges ?? [],
      availableFrom: availableFrom,
      availableTo: availableTo,
      soldOut: soldOut,
      unavailableDates: unavailableDates.isEmpty ? null : unavailableDates,
    );
  }).toList();
}();
