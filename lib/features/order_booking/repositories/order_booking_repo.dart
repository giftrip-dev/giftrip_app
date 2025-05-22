import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/order_booking/models/order_booking_category.dart';
import 'package:giftrip/features/order_booking/models/order_booking_model.dart';
import 'package:giftrip/features/order_booking/models/order_booking_detail_model.dart';
import 'package:giftrip/features/order_booking/repositories/mock_order_booking_data.dart';

class OrderBookingRepo {
  final Dio _dio = DioClient().to();

  /// 체험 상품 목록 조회
  Future<OrderBookingPageResponse> getOrderBookingList({
    OrderBookingCategory? category,
    int page = 1,
    int limit = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final filteredList = category != null
        ? mockOrderBookingList
            .where((item) => item.category == category)
            .toList()
        : mockOrderBookingList;

    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    if (startIndex >= filteredList.length) {
      return OrderBookingPageResponse(
        items: [],
        meta: PageMeta(
          currentPage: page,
          totalPages: (filteredList.length / limit).ceil(),
          totalItems: filteredList.length,
          itemsPerPage: limit,
        ),
      );
    }

    final items = filteredList.sublist(
      startIndex,
      endIndex > filteredList.length ? filteredList.length : endIndex,
    );

    return OrderBookingPageResponse(
      items: items,
      meta: PageMeta(
        currentPage: page,
        totalPages: (filteredList.length / limit).ceil(),
        totalItems: filteredList.length,
        itemsPerPage: limit,
      ),
    );
  }

  /// 체험 상품 상세 정보 조회
  Future<OrderBookingDetailModel> getOrderBookingDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final orderBooking = mockOrderBookingList.firstWhere(
      (item) => item.id == id,
      orElse: () => throw Exception('상품을 찾을 수 없습니다.'),
    );

    return OrderBookingDetailModel(
      id: orderBooking.id,
      title: orderBooking.title,
      description: orderBooking.description,
      thumbnailUrl: orderBooking.thumbnailUrl,
      originalPrice: orderBooking.originalPrice,
      finalPrice: orderBooking.finalPrice,
      category: orderBooking.category,
      rating: orderBooking.rating,
      reviewCount: orderBooking.reviewCount,
      discountRate: orderBooking.discountRate,
      availableFrom: orderBooking.availableFrom ?? DateTime.now(),
      availableTo: orderBooking.availableTo ?? DateTime.now(),
      soldOut: orderBooking.soldOut,
      unavailableDates: orderBooking.unavailableDates,
      location: '서울특별시 강남구 테헤란로 123',
      managerPhoneNumber: '010-1234-5678',
      progress: orderBooking.progress,
      paidAt: orderBooking.paidAt,
      reserverName: '홍길동',
      reserverPhoneNumber: '010-1234-5678',
      payMethod: '네이버페이',
      deliveryAddress: '서울 논현로 98길 28',
      deliveryDetail: '오피스타워 1층',
    );
  }
}
