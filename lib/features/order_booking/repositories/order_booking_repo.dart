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

    final item = mockOrderBookingList.firstWhere(
      (item) => item.id == id,
      orElse: () => throw Exception('상품을 찾을 수 없습니다.'),
    );

    return OrderBookingDetailModel(
      id: item.id,
      title: item.title,
      thumbnailUrl: item.thumbnailUrl,
      originalPrice: item.originalPrice,
      finalPrice: item.finalPrice,
      category: item.category,
      rating: item.rating,
      reviewCount: item.reviewCount,
      availableFrom: item.availableFrom,
      availableTo: item.availableTo,
      progress: item.progress,
      discountRate: item.discountRate,
      soldOut: item.soldOut,
      unavailableDates: item.unavailableDates,
      paidAt: item.paidAt,
      location: '서울시 강남구',
      managerPhoneNumber: '010-1234-5678',
      reserverName: '홍길동',
      reserverPhoneNumber: '010-9876-5432',
      payMethod: '신용카드',
    );
  }

  /// 예약/구매 취소
  Future<void> cancelOrderBooking(String id, {String? reason}) async {
    // 실제 API 호출 대신 목업 데이터 처리
    await Future.delayed(const Duration(milliseconds: 500));

    // 실제 구현에서는 아래와 같은 API 호출을 수행합니다
    // await _dio.post('/api/order-bookings/$id/cancel', data: {'reason': reason});
  }
}
