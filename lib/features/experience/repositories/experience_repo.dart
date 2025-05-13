import 'package:dio/dio.dart';
import 'package:myong/core/services/api_service.dart';
import 'package:myong/core/utils/page_meta.dart';
import 'package:myong/features/experience/models/experience_category.dart';
import 'package:myong/features/experience/models/experience_model.dart';
import 'package:myong/features/experience/repositories/mock_experience_data.dart';

class ExperienceRepo {
  final Dio _dio = DioClient().to();

  /// 체험 상품 목록 조회
  Future<ExperiencePageResponse> getExperienceList({
    ExperienceCategory? category,
    int page = 1,
    int limit = 10,
  }) async {
    // 목업 데이터를 불러오는 동안 0.5초 딜레이
    await Future.delayed(const Duration(milliseconds: 500));

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
}
