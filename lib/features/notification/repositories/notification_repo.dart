import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/features/notification/models/notification_model.dart';
import 'package:giftrip/core/utils/logger.dart';

class NotificationRepo {
  final Dio _dio = DioClient().to();

  /// 알림 목록 조회
  Future<NotificationResponse> getAllNotificationList() async {
    try {
      final response = await _dio.get('/api/notifications');

      if (response.statusCode == 200) {
        return NotificationResponse.fromJson(response.data);
      } else {
        throw Exception('알림 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('알림 조회 API 요청 실패: $e');
    }
  }

  /// 읽지 않은 알림 조회
  Future<NotificationResponse> getUnreadNotificationList() async {
    try {
      final response = await _dio.get('/api/notifications', queryParameters: {
        'isRead': false,
      });

      if (response.statusCode == 200) {
        return NotificationResponse.fromJson(response.data);
      } else {
        throw Exception('읽지 않은 알림 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('읽지 않은 알림 조회 API 요청 실패: $e');
    }
  }

  /// 알림 읽음 처리
  Future<void> readNotification({
    required String id,
  }) async {
    try {
      await _dio.patch('/api/notifications/$id/read');
    } catch (e) {
      throw Exception('알림 읽음 처리 실패: $e');
    }
  }

  /// 알림 전체 읽음 처리
  Future<void> readAllNotification() async {
    try {
      await _dio.patch('/api/notifications/read-all');
    } catch (e) {
      throw Exception('알림 전체 읽음 처리 실패: $e');
    }
  }

  /// 알림 삭제
  Future<void> deleteNotification({
    required String id,
  }) async {
    try {
      await _dio.delete('/api/notifications/$id');
    } catch (e) {
      throw Exception('알림 삭제 실패: $e');
    }
  }

  /// 알림 전체 삭제
  Future<void> deleteAllNotification() async {
    try {
      await _dio.delete('/api/notifications');
    } catch (e) {
      throw Exception('알림 전체 삭제 실패: $e');
    }
  }

  /// FCM 토큰 등록
  Future<void> registerFCMToken({
    required FCMTokenModel fcmData,
  }) async {
    try {
      await _dio.post('/api/fcm-tokens', data: fcmData.toJson());
    } catch (e) {
      throw Exception('FCM 토큰 등록 실패: $e');
    }
  }

  /// FCM 토큰 삭제
  Future<void> deleteFCMToken({
    required String token,
  }) async {
    try {
      await _dio.delete('/api/fcm-tokens', data: {
        'token': token,
      });
    } catch (e) {
      throw Exception('FCM 토큰 삭제 실패: $e');
    }
  }
}
