import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/core/services/storage_service.dart';
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

  Future<List<RequestModel>> getRequestList() async {
    try {
      // final response = await _dio.get('/api/user/request-list');
      // return RequestModel.fromJson(response.data);
      return mockRequestList;
    } catch (e) {
      throw Exception('취소,반품,교환 목록 조회 실패: $e');
    }
  }
}
