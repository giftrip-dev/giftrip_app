import 'package:giftrip/features/delivery/models/delivery_status.dart';
import 'package:giftrip/features/delivery/models/delivery_model.dart';
import 'package:giftrip/features/delivery/models/delivery_detail_model.dart';
import 'package:giftrip/features/home/models/product_model.dart';
import 'dart:math';

final random = Random();

/// 목업 체험 상품 데이터
final List<DeliveryModel> mockDeliveryList = [
  // 상품 준비중 3개
  for (int i = 0; i < 1; i++)
    DeliveryModel(
      id: '1',
      title: '준비중인 상품 ${i + 1}',
      thumbnailUrl: 'assets/png/banner.png',
      originalPrice: 10000 + i * 1000,
      finalPrice: 9000 + i * 1000,
      deliveryStatus: DeliveryStatus.preparing,
      paidAt: DateTime.now().subtract(Duration(days: i + 1)),
      option: '300g',
      quantity: 1,
    ),
  // 배송중 3개
  for (int i = 0; i < 2; i++)
    DeliveryModel(
      id: '2',
      title: '배송중인 상품 ${i + 1}',
      thumbnailUrl: 'assets/png/banner.png',
      originalPrice: 12000 + i * 1000,
      finalPrice: 11000 + i * 1000,
      deliveryStatus: DeliveryStatus.shipping,
      paidAt: DateTime.now().subtract(Duration(days: i + 2)),
      option: '500g',
      quantity: 2,
    ),
  // 배송 완료 2개
  for (int i = 0; i < 3; i++)
    DeliveryModel(
      id: '3',
      title: '체험단 상품 ${i + 1}',
      thumbnailUrl: 'assets/png/banner.png',
      originalPrice: 17000 + i * 1000,
      finalPrice: 16000 + i * 1000,
      deliveryStatus: DeliveryStatus.completed,
      paidAt: DateTime.now().subtract(Duration(days: i + 4)),
      option: '1kg',
      quantity: 1,
    ),
];

final List<DeliveryDetailModel> mockDeliveryDetailList = [
  DeliveryDetailModel(
    id: '1',
    deliveryNumber: 'a1234567890',
    deliveryStatus: DeliveryStatus.preparing,
    product: '상품 1',
    shippingFee: 0,
    invoiceNumber: '1234567890',
    ordererName: '홍길동',
    ordererPhone: '010-1234-5678',
    ordererEmail: 'hong@example.com',
    recipientName: '홍길동',
    recipientPhone: '010-9876-5432',
    address: '서울시 강남구',
    addressDetail: '123-456',
  ),
  DeliveryDetailModel(
    id: '2',
    deliveryNumber: 'b1234567890',
    deliveryStatus: DeliveryStatus.shipping,
    product: '상품 2',
    shippingFee: 2000,
    invoiceNumber: '1234567890',
    ordererName: '박길동',
    ordererPhone: '010-1234-5678',
    ordererEmail: 'park@example.com',
    recipientName: '박길동',
    recipientPhone: '010-9876-5432',
    address: '서울시 강남구',
    addressDetail: '123-456',
  ),
  DeliveryDetailModel(
    id: '2',
    deliveryNumber: 'b1234567890',
    deliveryStatus: DeliveryStatus.shipping,
    product: '상품 3',
    shippingFee: 0,
    invoiceNumber: '1234567890',
    ordererName: '김길동',
    ordererPhone: '010-1234-5678',
    ordererEmail: 'kim@example.com',
    recipientName: '김길동',
    recipientPhone: '010-9876-5432',
    address: '서울시 강남구',
    addressDetail: '123-456',
  ),
];
