import 'package:giftrip/features/lodging/models/lodging_category.dart';
import 'package:giftrip/features/lodging/models/lodging_model.dart';
import 'package:giftrip/features/home/models/product_model.dart';
import 'package:giftrip/features/lodging/models/location.dart';
import 'package:giftrip/features/home/view_models/product_view_model.dart';

/// 목업 숙박 상품 데이터
/// 홈스크린의 목업 데이터에서 숙소 타입만 필터링해서 LodgingModel로 변환
final List<LodgingModel> mockLodgingList = () {
  // 홈스크린 목업 데이터에서 숙소 타입만 필터링
  final lodgingProducts = mockProducts
      .where((product) => product.productType == ProductType.lodging)
      .toList();

  // ProductModel을 LodgingModel로 변환
  return lodgingProducts.map((product) {
    // ID에서 인덱스 추출 (lodging_1 -> 0, lodging_2 -> 1, ...)
    final index = int.parse(product.id.split('_')[1]) - 1;

    // 카테고리를 순환하면서 할당
    final categoryIndex = index % LodgingCategory.values.length;
    final category = LodgingCategory.values[categoryIndex];

    // 구매 가능 기간 설정 (현재로부터 1일 후 ~ 60일 후까지)
    final now = DateTime.now();
    final availableFrom = DateTime.now();
    final availableTo = now.add(Duration(days: 30 + (index % 30)));

    // 지역 설정
    final locations = [
      '서울',
      '인천',
      '가평/남양주/포천',
      '용인/수원/화성/평택',
      '파주/고양/김포',
      '이천/여주/안성/광주',
    ];
    final subLocation = locations[index % locations.length];
    final distanceInfo =
        '${subLocation.split('/')[0]}역 ${(index % 10 + 1) * 100}m';

    return LodgingModel(
      id: product.id, // 홈스크린과 동일한 ID 사용
      title: '${category.label} 상품 ${index + 1} ${subLocation}',
      description:
          '이것은 ${category.label} 상품 ${index + 1}의 상세 설명입니다. 편안한 휴식을 위한 최고의 선택이 될 것입니다.',
      thumbnailUrl: product.thumbnailUrl ?? '',
      mainLocation: MainLocation.sudogwon.label,
      subLocation: subLocation,
      distanceInfo: distanceInfo,
      originalPrice: product.originalPrice,
      finalPrice: product.finalPrice,
      category: category,
      rating: 3.5 + (index % 20) / 10, // 3.5 ~ 5.0 사이의 평점
      averageRating: 3.5 + (index % 20) / 10, // 3.5 ~ 5.0 사이의 평균 별점
      reviewCount: 10 + index, // 10개부터 1개씩 증가
      discountRate: product.discountRate,
      badges: product.badges ?? [],
      availableFrom: availableFrom,
      availableTo: availableTo,
    );
  }).toList();
}();
