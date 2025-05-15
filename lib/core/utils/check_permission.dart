import 'package:flutter/material.dart';
import 'package:giftrip/core/services/storage_service.dart';

Future<void> checkNotificationPermission(BuildContext context) async {
  // 현재 권한 상태를 확인
  final permissionStatus = await GlobalStorage().getNotificationPermission();

  // 알림 권한 요청
  await GlobalStorage().requestNotificationPermission();

  // 요청 후 다시 권한 상태 확인
  final currentStatus = await GlobalStorage().getNotificationPermission();

  if (currentStatus != null) {
    // 권한 상태가 변경된 경우
    if (currentStatus != permissionStatus) {
      await GlobalStorage().write("notificationPermission", currentStatus);
      print("알림 권한 상태가 변경되었습니다: $currentStatus");
    } else {
      print("알림 권한 상태: $permissionStatus");
    }
  } else {
    print("알림 권한 상태를 확인할 수 없습니다.");
  }
}
