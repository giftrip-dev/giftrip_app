import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/features/order_history/models/order_history_model.dart';
import 'package:giftrip/features/order_history/models/order_booking_detail_model.dart';
import 'package:giftrip/features/order_history/repositories/mock_order_booking_data.dart';

class OrderHistoryRepo {
  final Dio _dio = DioClient().to();

  /// 구매 내역 목록 조회
  Future<OrderBookingPageResponse> getOrderBookingList({
    ProductItemType? category,
    int page = 1,
    int limit = 10,
  }) async {
    // 실제 API 호출 코드 (현재 주석 처리)
    // try {
    //   final Map<String, dynamic> queryParams = {
    //     'page': page,
    //     'limit': limit,
    //   };
    //
    //   if (category != null) {
    //     queryParams['category'] = category.name;
    //   }
    //
    //   final response = await _dio.get(
    //     '/api/order-history',
    //     queryParameters: queryParams,
    //   );
    //
    //   return OrderBookingPageResponse.fromJson(response.data);
    // } catch (e) {
    //   // 에러 처리
    // }

    // 목업 데이터 사용
    await Future.delayed(const Duration(milliseconds: 200));

    final filteredList = category != null
        ? mockOrderBookingList
            .where(
                (item) => item.items.any((item) => item.category == category))
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

  /// 구매 내역 상세 정보 조회
  Future<OrderBookingDetailModel> getOrderBookingDetail(String id) async {
    // 실제 API 호출 코드 (현재 주석 처리)
    // try {
    //   final response = await _dio.get('/api/order-history/$id');
    //   return OrderBookingDetailModel.fromJson(response.data);
    // } catch (e) {
    //   // 에러 처리
    // }

    // 목업 데이터 사용
    await Future.delayed(const Duration(milliseconds: 200));

    final item = mockOrderBookingList.firstWhere(
      (item) => item.id == id,
      orElse: () => throw Exception('구매 내역을 찾을 수 없습니다.'),
    );

    return OrderBookingDetailModel(
      id: item.id,
      orderName: item.orderName,
      items: item.items,
      totalAmount: item.totalAmount,
      progress: item.progress,
      paidAt: item.paidAt,
      location: '서울시 강남구',
      managerPhoneNumber: '010-1234-5678',
      reserverName: '홍길동',
      reserverPhoneNumber: '010-9876-5432',
      payMethod: '신용카드',
      transactionId: 'TXN${item.id.toUpperCase()}240101',
    );
  }

  /// 예약/구매 취소
  Future<void> cancelOrderBooking(String id, {String? reason}) async {
    // 실제 API 호출 코드 (현재 주석 처리)
    // try {
    //   final Map<String, dynamic> data = {};
    //   if (reason != null) {
    //     data['reason'] = reason;
    //   }
    //
    //   await _dio.post('/api/order-history/$id/cancel', data: data);
    // } catch (e) {
    //   // 에러 처리
    //   rethrow;
    // }

    // 목업 데이터 처리
    await Future.delayed(const Duration(milliseconds: 500));
    // 실제로는 목업 데이터에서 해당 아이템의 상태를 변경하거나
    // 취소 처리 로직을 수행할 수 있습니다.
  }
}
