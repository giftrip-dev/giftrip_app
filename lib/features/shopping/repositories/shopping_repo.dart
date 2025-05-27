import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/shopping/models/shopping_category.dart';
import 'package:giftrip/features/shopping/models/shopping_model.dart';
import 'package:giftrip/features/shopping/models/shopping_detail_model.dart';
import 'package:giftrip/features/shopping/repositories/mock_shopping_data.dart';

class ShoppingRepo {
  final Dio _dio = DioClient().to();

  /// 쇼핑 상품 목록 조회
  Future<ShoppingPageResponse> getShoppingList({
    ShoppingCategory? category,
    int page = 1,
    int limit = 10,
  }) async {
    // 데이터를 불러오는 동안 0.2초 딜레이
    await Future.delayed(const Duration(milliseconds: 200));

    // 카테고리로 필터링
    final filteredList = category != null
        ? mockShoppingList.where((item) => item.category == category).toList()
        : mockShoppingList;

    // 페이지네이션 처리
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    // 데이터가 범위를 벗어나지 않도록 체크
    if (startIndex >= filteredList.length) {
      return ShoppingPageResponse(
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

    return ShoppingPageResponse(
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
      final response = await _dio.get('/api/shopping', queryParameters: {
        'category': category?.name,
        'page': page,
        'limit': limit,
      });

      if (response.statusCode == 200) {
        return ShoppingPageResponse.fromJson(response.data);
      } else {
        throw Exception('쇼핑 상품 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('쇼핑 상품 조회 API 요청 실패: $e');
    }*/
  }

  /// 쇼핑 상품 상세 정보 조회
  Future<ShoppingDetailModel> getShoppingDetail(String id) async {
    // try {
    //   final response = await _dio.get('/api/shopping/$id');

    //   if (response.statusCode == 200) {
    //     return ShoppingDetailModel.fromJson(response.data);
    //   } else {
    //     throw Exception('쇼핑 상품 상세 정보 조회 실패: ${response.statusCode}');
    //   }
    // } catch (e) {
    //   throw Exception('쇼핑 상품 상세 정보 API 요청 실패: $e');
    // }

    // 데이터를 불러오는 동안 0.2초 딜레이
    await Future.delayed(const Duration(milliseconds: 200));

    // 기본 상품 정보 찾기
    final shopping = mockShoppingList.firstWhere(
      (item) => item.id == id,
      orElse: () => throw Exception('상품을 찾을 수 없습니다.'),
    );

    // 상세 정보 생성 (목업)
    return ShoppingDetailModel(
      id: shopping.id,
      title: shopping.title,
      description: shopping.description,
      thumbnailUrl: shopping.thumbnailUrl,
      originalPrice: shopping.originalPrice,
      finalPrice: shopping.finalPrice,
      category: shopping.category,
      rating: shopping.rating,
      averageRating: shopping.averageRating,
      reviewCount: shopping.reviewCount,
      badges: shopping.badges,
      manufacturer: shopping.manufacturer,
      discountRate: shopping.discountRate,
      soldOut: shopping.soldOut,
      location: '서울특별시 강남구 테헤란로 123',
      managerPhoneNumber: '010-1234-5678',
      relatedLink: 'https://example.com/shopping/${shopping.id}',
      detailImageUrl: 'assets/png/product_detail.png',
      croppedDetailImageUrl: 'assets/png/product_detail.png',
      inquiryInfo: const InformationSection(
        title: '문의하기',
        content: '쇼핑 상품 관련 문의사항이 있으시면 담당자에게 연락 부탁드립니다.',
      ),
      changeInfo: const InformationSection(
        title: '교환/환불 안내',
        content:
            '• 상품 수령 후 7일 이내에 교환/환불이 가능합니다.\n• 상품 하자 시에는 배송비 무료입니다.\n• 단순 변심의 경우 왕복 배송비 고객 부담입니다.',
      ),
      deliveryInfo:
          '• 배송비: 3,000원 (30,000원 이상 구매 시 무료배송)\n• 배송기간: 결제 확인 후 2~5일 이내 발송',
      options: shopping.options,
    );
  }
}
