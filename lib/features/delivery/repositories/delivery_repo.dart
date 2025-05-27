import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/delivery/models/delivery_status.dart';
import 'package:giftrip/features/delivery/models/delivery_model.dart';
import 'package:giftrip/features/delivery/models/delivery_detail_model.dart';
import 'package:giftrip/features/delivery/repositories/mock_delivery_data.dart';

class DeliveryRepo {
  final Dio _dio = DioClient().to();

  /// 체험 상품 목록 조회
  Future<DeliveryPageResponse> getDeliveryList({
    DeliveryStatus? status,
    int page = 1,
    int limit = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final filteredList = status != null
        ? mockDeliveryList
            .where((item) => item.deliveryStatus == status)
            .toList()
        : mockDeliveryList;

    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    if (startIndex >= filteredList.length) {
      return DeliveryPageResponse(
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

    return DeliveryPageResponse(
      items: items,
      meta: PageMeta(
        currentPage: page,
        totalPages: (filteredList.length / limit).ceil(),
        totalItems: filteredList.length,
        itemsPerPage: limit,
      ),
    );
  }

  /// 상품 상세 정보 조회
  Future<DeliveryDetailModel> getDeliveryDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final detail = mockDeliveryDetailList.firstWhere(
      (item) => item.id == id,
      orElse: () => throw Exception('상세 정보를 찾을 수 없습니다.'),
    );

    return detail;
  }

  /// 예약/구매 취소
  Future<void> cancelDelivery(String id, {String? reason}) async {
    // 실제 API 호출 대신 목업 데이터 처리
    await Future.delayed(const Duration(milliseconds: 500));

    // 실제 구현에서는 아래와 같은 API 호출을 수행합니다
    // await _dio.post('/api/order-bookings/$id/cancel', data: {'reason': reason});
  }
}
