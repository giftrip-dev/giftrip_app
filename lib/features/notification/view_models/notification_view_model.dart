import 'package:flutter/material.dart';
import 'package:myong/core/utils/logger.dart';
import 'package:myong/features/notification/models/notification_model.dart';
import 'package:myong/features/notification/repositories/notification_repo.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationRepo _notificationRepo = NotificationRepo();

  // 상태
  List<NotificationModel> _notificationList = [];
  bool _isLoading = false;
  // Getter
  List<NotificationModel> get notificationList => _notificationList;
  bool get isLoading => _isLoading;

  /// 📌 알림 목록 조회
  Future<void> fetchNotificationList() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _notificationRepo.getAllNotificationList();
      _notificationList = response.items;
      notifyListeners();
    } catch (e) {
      logger.e('알림 불러오기 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 📌 읽지 않은 알림 목록 조회
  Future<void> fetchUnreadNotificationList() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _notificationRepo.getUnreadNotificationList();
      _notificationList = response.items;
      notifyListeners();
    } catch (e) {
      logger.e('읽지 않은 알림 불러오기 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 📌 알림 읽음 처리
  Future<void> readNotification({required String id}) async {
    await _notificationRepo.readNotification(id: id);
    await fetchNotificationList();
    notifyListeners();
  }

  /// 📌 알림 전체 읽음 처리
  Future<void> readAllNotification() async {
    await _notificationRepo.readAllNotification();
    await fetchNotificationList();
    notifyListeners();
  }

  /// 📌 알림 삭제
  Future<void> deleteNotification({required String id}) async {
    await _notificationRepo.deleteNotification(id: id);
    await fetchNotificationList();
    notifyListeners();
  }

  /// 📌 알림 전체 삭제
  Future<void> deleteAllNotification() async {
    await _notificationRepo.deleteAllNotification();
    await fetchNotificationList();
    notifyListeners();
  }

  /// 📌 FCM 토큰 등록
  Future<void> registerFCMToken({
    required FCMTokenModel fcmData,
  }) async {
    try {
      await _notificationRepo.registerFCMToken(fcmData: fcmData);
    } catch (e) {
      logger.e('FCM 토큰 등록 실패: $e');
    }
  }

  /// 📌 FCM 토큰 삭제
  Future<void> deleteFCMToken({
    required String token,
  }) async {
    try {
      await _notificationRepo.deleteFCMToken(token: token);
    } catch (e) {
      logger.e('FCM 토큰 삭제 실패: $e');
    }
  }
}
