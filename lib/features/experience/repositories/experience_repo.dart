import 'package:dio/dio.dart';
import 'package:myong/core/services/api_service.dart';
import 'package:myong/core/utils/page_meta.dart';
import 'package:myong/features/experience/models/experience_category.dart';
import 'package:myong/features/experience/models/experience_model.dart';
import 'package:myong/features/experience/models/experience_detail_model.dart';
import 'package:myong/features/experience/repositories/mock_experience_data.dart';

class ExperienceRepo {
  final Dio _dio = DioClient().to();

  /// 체험 상품 목록 조회
  Future<ExperiencePageResponse> getExperienceList({
    ExperienceCategory? category,
    int page = 1,
    int limit = 10,
  }) async {
    // 데이터를 불러오는 동안 0.2초 딜레이
    await Future.delayed(const Duration(milliseconds: 200));

    // 카테고리로 필터링
    final filteredList = category != null
        ? mockExperienceList.where((item) => item.category == category).toList()
        : mockExperienceList;

    // 페이지네이션 처리
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    // 데이터가 범위를 벗어나지 않도록 체크
    if (startIndex >= filteredList.length) {
      return ExperiencePageResponse(
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

    return ExperiencePageResponse(
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
      final response = await _dio.get('/api/experiences', queryParameters: {
        'category': category?.name,
        'page': page,
        'limit': limit,
      });

      if (response.statusCode == 200) {
        return ExperiencePageResponse.fromJson(response.data);
      } else {
        throw Exception('체험 상품 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('체험 상품 조회 API 요청 실패: $e');
    }*/
  }

  /// 체험 상품 상세 정보 조회
  Future<ExperienceDetailModel> getExperienceDetail(String id) async {
    // try {
    //   final response = await _dio.get('/api/experiences/$id');

    //   if (response.statusCode == 200) {
    //     return ExperienceDetailModel.fromJson(response.data);
    //   } else {
    //     throw Exception('체험 상품 상세 정보 조회 실패: ${response.statusCode}');
    //   }
    // } catch (e) {
    //   throw Exception('체험 상품 상세 정보 API 요청 실패: $e');
    // }

    // 데이터를 불러오는 동안 0.2초 딜레이
    await Future.delayed(const Duration(milliseconds: 200));

    // 기본 상품 정보 찾기
    final experience = mockExperienceList.firstWhere(
      (item) => item.id == id,
      orElse: () => throw Exception('상품을 찾을 수 없습니다.'),
    );

    // 상세 정보 생성 (목업)
    return ExperienceDetailModel(
      id: experience.id,
      title: experience.title,
      description: experience.description,
      thumbnailUrl: experience.thumbnailUrl,
      originalPrice: experience.originalPrice,
      finalPrice: experience.finalPrice,
      category: experience.category,
      rating: experience.rating,
      reviewCount: experience.reviewCount,
      badges: experience.badges,
      discountRate: experience.discountRate,
      location: '서울특별시 강남구 테헤란로 123',
      managerPhoneNumber: '010-1234-5678',
      relatedLink: 'https://example.com/experience/${experience.id}',
      detailImageUrl: 'assets/png/product_detail.png',
      croppedDetailImageUrl: 'assets/png/product_detail.png',
      inquiryInfo: const InformationSection(
        title: '문의하기',
        content: '체험 상품 관련 문의사항이 있으시면 담당자에게 연락 부탁드립니다.',
      ),
      changeInfo: const InformationSection(
        title: '변경 안내',
        content:
            '• 예약 변경은 체험 시작일 3일 전까지 가능합니다.\n• 예약 변경 시 차액이 발생할 수 있습니다.\n• 변경 횟수는 1회로 제한됩니다.',
      ),
      availablePeriod: AvailablePeriod(
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)),
      ),
      durationInDays: 1 + (experience.id.hashCode % 3), // 1~3일 랜덤 생성
    );
  }
}
