import 'package:giftrip/features/order_booking/models/order_booking_category.dart';
import 'package:giftrip/features/order_booking/models/order_booking_model.dart';
import 'package:giftrip/features/home/models/product_model.dart';
import 'dart:math';

final random = Random();

/// 목업 체험 상품 데이터
final List<OrderBookingModel> mockOrderBookingList = [
  // 숙박 3개
  for (int i = 0; i < 3; i++)
    OrderBookingModel(
      id: 'res_lodging_${i + 1}',
      title: '숙박 상품 ${i + 1}',
      description: '이것은 숙박 상품 ${i + 1}의 상세 설명입니다.',
      thumbnailUrl: 'assets/png/banner.png',
      originalPrice: 10000 + i * 1000,
      finalPrice: 9000 + i * 1000,
      category: OrderBookingCategory.lodging,
      rating: 4.0 + (i % 2) * 0.5,
      reviewCount: 10 + i,
      discountRate: i % 2 == 0 ? 10 : null,
      availableFrom: DateTime.now().add(Duration(days: 1)),
      availableTo: DateTime.now().add(Duration(days: 30)),
      soldOut: false,
      unavailableDates: null,
      progress: i % 2 == 0
          ? OrderBookingProgress.confirmed
          : OrderBookingProgress.completed,
      paidAt: DateTime.now().subtract(Duration(days: i + 1)),
    ),
  // 체험 3개
  for (int i = 0; i < 3; i++)
    OrderBookingModel(
      id: 'res_experience_${i + 1}',
      title: '체험 상품 ${i + 1}',
      description: '이것은 체험 상품 ${i + 1}의 상세 설명입니다.',
      thumbnailUrl: 'assets/png/banner.png',
      originalPrice: 12000 + i * 1000,
      finalPrice: 11000 + i * 1000,
      category: OrderBookingCategory.experience,
      rating: 4.2 + (i % 2) * 0.5,
      reviewCount: 20 + i,
      discountRate: i % 2 == 0 ? 15 : null,
      availableFrom: DateTime.now().add(Duration(days: 2)),
      availableTo: DateTime.now().add(Duration(days: 32)),
      soldOut: false,
      unavailableDates: null,
      progress: i % 2 == 0
          ? OrderBookingProgress.completed
          : OrderBookingProgress.confirmed,
      paidAt: DateTime.now().subtract(Duration(days: i + 2)),
    ),
  // 상품 4개
  for (int i = 0; i < 4; i++)
    OrderBookingModel(
      id: 'res_product_${i + 1}',
      title: '상품 ${i + 1}',
      description: '이것은 상품 ${i + 1}의 상세 설명입니다.',
      thumbnailUrl: 'assets/png/banner.png',
      originalPrice: 15000 + i * 1000,
      finalPrice: 14000 + i * 1000,
      category: OrderBookingCategory.product,
      rating: 4.5 + (i % 2) * 0.3,
      reviewCount: 30 + i,
      discountRate: i % 2 == 0 ? 20 : null,
      availableFrom: DateTime.now().add(Duration(days: 3)),
      availableTo: DateTime.now().add(Duration(days: 33)),
      soldOut: false,
      unavailableDates: null,
      progress: i % 2 == 0
          ? OrderBookingProgress.confirmed
          : OrderBookingProgress.completed,
      paidAt: DateTime.now().subtract(Duration(days: i + 3)),
    ),
  // 체험단 2개
  for (int i = 0; i < 2; i++)
    OrderBookingModel(
      id: 'res_exgroup_${i + 1}',
      title: '체험단 상품 ${i + 1}',
      description: '이것은 체험단 상품 ${i + 1}의 상세 설명입니다.',
      thumbnailUrl: 'assets/png/banner.png',
      originalPrice: 17000 + i * 1000,
      finalPrice: 16000 + i * 1000,
      category: OrderBookingCategory.experienceGroup,
      rating: 4.7 + (i % 2) * 0.2,
      reviewCount: 40 + i,
      discountRate: i % 2 == 0 ? 25 : null,
      availableFrom: DateTime.now().add(Duration(days: 4)),
      availableTo: DateTime.now().add(Duration(days: 34)),
      soldOut: false,
      unavailableDates: null,
      progress: i % 2 == 0
          ? OrderBookingProgress.completed
          : OrderBookingProgress.confirmed,
      paidAt: DateTime.now().subtract(Duration(days: i + 4)),
    ),
];
