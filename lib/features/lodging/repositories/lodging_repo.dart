import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/lodging/models/lodging_category.dart';
import 'package:giftrip/features/lodging/models/lodging_model.dart';
import 'package:giftrip/features/lodging/models/lodging_detail_model.dart';
import 'package:giftrip/features/lodging/repositories/mock_lodging_data.dart';

class LodgingRepo {
  final Dio _dio = DioClient().to();

  /// 숙박 상품 목록 조회
  Future<LodgingPageResponse> getLodgingList({
    LodgingCategory? category,
    int page = 1,
    int limit = 10,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // 데이터를 불러오는 동안 0.2초 딜레이
    await Future.delayed(const Duration(milliseconds: 200));

    // 필터링 적용
    var filteredList = mockLodgingList;

    // 카테고리 필터링
    if (category != null) {
      filteredList =
          filteredList.where((item) => item.category == category).toList();
    }

    // 지역 필터링
    if (location != null && location.isNotEmpty) {
      filteredList =
          filteredList.where((item) => item.subLocation == location).toList();
    }

    // 날짜 필터링
    if (startDate != null && endDate != null) {
      filteredList = filteredList.where((item) {
        // 상품의 구매 가능 기간이 선택된 날짜 범위와 겹치는지 확인
        final itemStart = item.availableFrom;
        final itemEnd = item.availableTo;

        // 선택된 날짜 범위가 상품의 구매 가능 기간 내에 있는지 확인
        return !itemStart.isAfter(endDate) && !itemEnd.isBefore(startDate);
      }).toList();
    }

    // 페이지네이션 처리
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    // 데이터가 범위를 벗어나지 않도록 체크
    if (startIndex >= filteredList.length) {
      return LodgingPageResponse(
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

    return LodgingPageResponse(
      items: items,
      meta: PageMeta(
        currentPage: page,
        totalPages: (filteredList.length / limit).ceil(),
        totalItems: filteredList.length,
        itemsPerPage: limit,
      ),
    );

    // todo: API 호출 코드 (나중에 사용)
    /*try {
      final response = await _dio.get('/api/lodgings', queryParameters: {
        'category': category?.name,
        'page': page,
        'limit': limit,
      });

      if (response.statusCode == 200) {
        return LodgingPageResponse.fromJson(response.data);
      } else {
        throw Exception('숙박 상품 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('숙박 상품 조회 API 요청 실패: $e');
    }*/
  }

  /// 숙박 상품 상세 정보 조회
  Future<LodgingDetailModel> getLodgingDetail(String id) async {
    // try {
    //   final response = await _dio.get('/api/lodgings/$id');

    //   if (response.statusCode == 200) {
    //     return LodgingDetailModel.fromJson(response.data);
    //   } else {
    //     throw Exception('숙박 상품 상세 정보 조회 실패: ${response.statusCode}');
    //   }
    // } catch (e) {
    //   throw Exception('숙박 상품 상세 정보 API 요청 실패: $e');
    // }

    // 데이터를 불러오는 동안 0.2초 딜레이
    await Future.delayed(const Duration(milliseconds: 200));

    // 기본 상품 정보 찾기
    final lodging = mockLodgingList.firstWhere(
      (item) => item.id == id,
      orElse: () => throw Exception('상품을 찾을 수 없습니다.'),
    );

    // 상세 정보 생성 (목업)
    return LodgingDetailModel(
      id: lodging.id,
      title: lodging.title,
      description: lodging.description,
      thumbnailUrl: lodging.thumbnailUrl,
      originalPrice: lodging.originalPrice,
      finalPrice: lodging.finalPrice,
      category: lodging.category,
      rating: lodging.rating,
      reviewCount: lodging.reviewCount,
      badges: lodging.badges,
      discountRate: lodging.discountRate,
      availableFrom: lodging.availableFrom,
      availableTo: lodging.availableTo,
      mainLocation: lodging.mainLocation,
      subLocation: lodging.subLocation,
      distanceInfo: lodging.distanceInfo,
      managerPhoneNumber: '010-1234-5678',
      relatedLink: 'https://example.com/lodging/${lodging.id}',
      detailImageUrl: 'assets/png/product_detail.png',
      croppedDetailImageUrl: 'assets/png/product_detail.png',
      inquiryInfo: const InformationSection(
        title: '문의하기',
        content: '숙박 상품 관련 문의사항이 있으시면 담당자에게 연락 부탁드립니다.',
      ),
      changeInfo: const InformationSection(
        title: '변경 안내',
        content:
            '• 예약 변경은 체크인 3일 전까지 가능합니다.\n• 예약 변경 시 차액이 발생할 수 있습니다.\n• 변경 횟수는 1회로 제한됩니다.',
      ),
      availablePeriod: AvailablePeriod(
        startDate: lodging.availableFrom,
        endDate: lodging.availableTo,
      ),
      durationInDays: 1 + (lodging.id.hashCode % 3), // 1~3일 랜덤 생성
    );
  }
}
