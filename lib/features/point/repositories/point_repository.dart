import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/features/point/models/point_model.dart';

class PointRepository {
  final Dio _dio = DioClient().to();

  PointRepository();

  Future<PointModel> getPoint() async {
    try {
      final response = await _dio.get('/api/v1/points');
      return PointModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
