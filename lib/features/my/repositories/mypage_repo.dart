import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/core/services/storage_service.dart';
import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/my/models/request_model.dart';
import 'package:giftrip/features/my/models/user_model.dart';
import 'package:giftrip/features/my/repositories/mock_request_data.dart';
import 'package:giftrip/features/my/repositories/mock_user_data.dart';

class MyPageRepository {
  final Dio _dio = DioClient().to();
  final Map<String, dynamic> resultMap = <String, dynamic>{};
  final GlobalStorage _storage = GlobalStorage();

  Future<UserModel> getUserInfo() async {
    try {
      // final response = await _dio.get('/api/user/info');
      // return UserModel.fromJson(response.data);
      return mockUser;
    } catch (e) {
      throw Exception('유저 정보 조회 실패: $e');
    }
  }

  Future<UserModel> getUserManagement() async {
    try {
      // final response = await _dio.get('/api/user/management');
      // return UserModel.fromJson(response.data);
      return mockUserManagement;
    } catch (e) {
      throw Exception('회원 관리 정보 조회 실패: $e');
    }
  }

  Future<RequestPageResponse> getRequestList({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));

      final startIndex = (page - 1) * limit;
      final endIndex = startIndex + limit;

      if (startIndex >= mockRequestList.length) {
        return RequestPageResponse(
          items: [],
          meta: PageMeta(
            currentPage: page,
            totalPages: (mockRequestList.length / limit).ceil(),
            totalItems: mockRequestList.length,
            itemsPerPage: limit,
          ),
        );
      }

      final items = mockRequestList.sublist(
        startIndex,
        endIndex > mockRequestList.length ? mockRequestList.length : endIndex,
      );

      return RequestPageResponse(
        items: items,
        meta: PageMeta(
          currentPage: page,
          totalPages: (mockRequestList.length / limit).ceil(),
          totalItems: mockRequestList.length,
          itemsPerPage: limit,
        ),
      );
    } catch (e) {
      throw Exception('취소,반품,교환 목록 조회 실패: $e');
    }
  }
}

class RequestPageResponse {
  final List<RequestModel> items;
  final PageMeta meta;

  RequestPageResponse({
    required this.items,
    required this.meta,
  });
}
