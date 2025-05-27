import 'package:giftrip/features/delivery/models/delivery_status.dart';
import 'package:giftrip/features/delivery/models/delivery_model.dart';
import 'package:giftrip/features/home/models/product_model.dart';
import 'dart:math';

final random = Random();

/// 목업 체험 상품 데이터
final List<DeliveryModel> mockDeliveryList = [
  // 상품 준비중 3개
  for (int i = 0; i < 1; i++)
    DeliveryModel(
      id: 'res_lodging_${i + 1}',
      title: '준비중인 상품 ${i + 1}',
      thumbnailUrl: 'assets/png/banner.png',
      originalPrice: 10000 + i * 1000,
      finalPrice: 9000 + i * 1000,
      status: DeliveryStatus.preparing,
      rating: 4.0 + (i % 2) * 0.5,
      reviewCount: 10 + i,
      discountRate: i % 2 == 0 ? 10 : null,
      availableFrom: DateTime.now().add(Duration(days: 1)),
      availableTo: DateTime.now().add(Duration(days: 30)),
      soldOut: false,
      unavailableDates: null,
      paidAt: DateTime.now().subtract(Duration(days: i + 1)),
      option: '300g',
      quantity: 1,
    ),
  // 배송중 3개
  for (int i = 0; i < 2; i++)
    DeliveryModel(
      id: 'res_experience_${i + 1}',
      title: '배송중인 상품 ${i + 1}',
      thumbnailUrl: 'assets/png/banner.png',
      originalPrice: 12000 + i * 1000,
      finalPrice: 11000 + i * 1000,
      status: DeliveryStatus.shipping,
      rating: 4.2 + (i % 2) * 0.5,
      reviewCount: 20 + i,
      discountRate: i % 2 == 0 ? 15 : null,
      availableFrom: DateTime.now().add(Duration(days: 2)),
      availableTo: DateTime.now().add(Duration(days: 32)),
      soldOut: false,
      unavailableDates: null,
      paidAt: DateTime.now().subtract(Duration(days: i + 2)),
      option: '500g',
      quantity: 2,
    ),
  // 배송 완료 2개
  for (int i = 0; i < 3; i++)
    DeliveryModel(
      id: 'res_exgroup_${i + 1}',
      title: '체험단 상품 ${i + 1}',
      thumbnailUrl: 'assets/png/banner.png',
      originalPrice: 17000 + i * 1000,
      finalPrice: 16000 + i * 1000,
      status: DeliveryStatus.completed,
      rating: 4.7 + (i % 2) * 0.2,
      reviewCount: 40 + i,
      discountRate: i % 2 == 0 ? 25 : null,
      availableFrom: DateTime.now().add(Duration(days: 4)),
      availableTo: DateTime.now().add(Duration(days: 34)),
      soldOut: false,
      unavailableDates: null,
      paidAt: DateTime.now().subtract(Duration(days: i + 4)),
      option: '1kg',
      quantity: 1,
    ),
];
