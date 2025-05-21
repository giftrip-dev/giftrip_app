import 'package:giftrip/features/reservation/models/reservation_category.dart';
import 'package:giftrip/features/reservation/models/reservation_model.dart';
import 'package:giftrip/features/home/models/product_model.dart';
import 'dart:math';

final random = Random();

/// 목업 체험 상품 데이터
final List<ReservationModel> mockReservationList = List.generate(
  50,
  (index) {
    // 카테고리를 순환하면서 할당
    final categoryIndex = index % ReservationCategory.values.length;
    final category = ReservationCategory.values[categoryIndex];

    // 5개 중 2개는 할인 적용 (0~50% 할인)
    final hasDiscount = index % 5 < 2;
    final originalPrice = 10000 + (index * 1000); // 10,000원부터 1,000원씩 증가
    final discountRate = hasDiscount ? ((index % 5 + 1) * 10) : null;
    final finalPrice = discountRate != null
        ? (originalPrice * (100 - discountRate) ~/ 100)
        : originalPrice;

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

    final progress = ReservationProgress
        .values[random.nextInt(ReservationProgress.values.length)];

    // 결제 날짜는 오늘로부터 1~7일 전 중 랜덤하게 설정
    final paidAt = now.subtract(Duration(days: (index % 7) + 1));

    return ReservationModel(
      id: 'res_${index + 1}',
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
      availableFrom: availableFrom,
      availableTo: availableTo,
      soldOut: soldOut,
      unavailableDates: unavailableDates.isEmpty ? null : unavailableDates,
      progress: progress,
      paidAt: paidAt,
    );
  },
);
