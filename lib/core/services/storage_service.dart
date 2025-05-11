import 'dart:convert';
import 'dart:io';
import 'package:myong/core/utils/logger.dart';
import 'package:myong/features/auth/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:myong/core/utils/logger.dart';

class GlobalStorage {
  static const _storage = FlutterSecureStorage();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // [공통 메서드] - 쓰기 (public으로 변경)
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // [공통 메서드] - 읽기
  Future<String?> _read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (error) {
      logger.e("읽기 실패 ($key): $error");
      return null;
    }
  }

  // [공통 메서드] - 삭제
  Future<void> _delete(String key) async {
    await _storage.delete(key: key);
  }

  // 🔹 유저 정보 저장
  Future<void> setUserInfo(UserModel user) async {
    await write("userInfo", jsonEncode(user.toJson()));
  }

  // 🔹 유저 정보 조회
  Future<UserModel?> getUserInfo() async {
    final jsonString = await _read("userInfo");
    return jsonString != null
        ? UserModel.fromJson(jsonDecode(jsonString))
        : null;
  }

  // 🔹 유저 정보 삭제
  Future<void> deleteUserInfo() async => _delete("userInfo");

  // 🔹 자동 로그인 저장, 조회, 삭제
  Future<void> setAutoLogin() async => write("autoLogin", "T");
  Future<bool> getAutoLogin() async => (await _read("autoLogin")) == "T";
  Future<void> removeAutoLogin() async => write("autoLogin", "N");

  // 🔹 토큰 저장, 조회, 삭제
  Future<void> setToken(String accessToken, String refreshToken) async {
    await write("accessToken", accessToken);
    await write("refreshToken", refreshToken);
  }

  Future<String?> getAccessToken() async => _read("accessToken");
  Future<String?> getRefreshToken() async => _read("refreshToken");

  Future<void> deleteLoginToken() async {
    await _delete("accessToken");
    await _delete("refreshToken");
  }

  Future<void> deleteAccessToken() async {
    await _delete("accessToken");
    logger.d("accessToken delete: ${await getAccessToken()}");
  }

  // 🔹 특정 키 삭제
  Future<void> deleteSpecificKeys() async {
    const keysToDelete = [
      "userInfo",
      "autoLogin",
      "accessToken",
      "refreshToken"
    ];
    for (final key in keysToDelete) {
      await _delete(key);
    }
  }

  // 🔹 전체 스토리지 삭제
  Future<void> deleteAllStorage() async => _storage.deleteAll();

  // 🔹 Device ID 저장/불러오기
  Future<void> setDeviceId(String deviceId) async =>
      write("deviceId", deviceId);
  Future<String?> getDeviceId() async => _read("deviceId");

  // 🔹 Device model 저장/불러오기
  Future<void> setDeviceModel(String deviceModel) async =>
      write("deviceModel", deviceModel);
  Future<String?> getDeviceModel() async => _read("deviceModel");

  // 🔹 FCM 토큰 저장/불러오기
  Future<void> setFcmToken(String token) async => write("fcmToken", token);
  Future<String?> getFcmToken() async => _read("fcmToken");

  // 🔹 알림 권한 요청 및 저장
  Future<void> requestNotificationPermission() async {
    final isPermissionSelected = await getNotificationPermissionSelected();
    print("알림 권한 요청 및 저장 $isPermissionSelected");
    if (Platform.isIOS) {
      print("애플 알림 권한 요청 및 저장");

      final permissionStatus = await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

      // iOS의 경우
      if (permissionStatus != null) {
        await write(
            "notificationPermission", permissionStatus ? "granted" : "denied");
        await setNotificationPermissionSelected(true); // 권한 요청 후 true로 설정
      }
    } else if (Platform.isAndroid) {
      logger.d("android permission request and save");
      // Android 13 이상에서 알림 권한 요청
      final permissionStatus = await Permission.notification.request();

      if (permissionStatus.isGranted) {
        await write("notificationPermission", "granted");
        await setNotificationPermissionSelected(true); // 권한 요청 후 true로 설정
      } else {
        await write("notificationPermission", "denied");
        await setNotificationPermissionSelected(true); // 권한 요청 후 false로 설정
      }
    }
  }

  // 🔹 알림 권한 선택 여부 저장
  Future<void> setNotificationPermissionSelected(bool permission) async =>
      write("notificationPermissionSelected", permission ? "true" : "false");

  Future<bool> getNotificationPermissionSelected() async {
    final value = await _read("notificationPermissionSelected");
    return value == "true";
  }

  // 🔹 알림 권한 상태 조회
  Future<String?> getNotificationPermission() async {
    return await _read("notificationPermission");
  }

  Future<void> setServiceTermsComplete() async =>
      write("serviceTermsComplete", "true");
  Future<bool> getServiceTermsComplete() async =>
      (await _read("serviceTermsComplete")) == "true";

  Future<void> setCertificateComplete() async =>
      write("certificateComplete", "true");
  Future<bool> getCertificateComplete() async =>
      (await _read("certificateComplete")) == "true";

  Future<void> setNicknameComplete() async => write("nicknameComplete", "true");
  Future<bool> getNicknameComplete() async =>
      (await _read("nicknameComplete")) == "true";

  /// 최근 검색어 저장/불러오기
  Future<void> setRecentSearch(String search) async {
    List<String> currentSearches = await getRecentSearch() ?? [];

    // 중복 검색어 제거
    currentSearches.remove(search);

    // 새로운 검색어를 맨 앞에 추가
    currentSearches = [search, ...currentSearches];
    await write("recentSearches", jsonEncode(currentSearches));
    print("currentSearches: $currentSearches");
  }

  Future<List<String>?> getRecentSearch() async {
    final jsonString = await _read("recentSearches");
    if (jsonString != null) {
      // List<dynamic>을 List<String>으로 변환
      return (jsonDecode(jsonString) as List)
          .map((item) => item as String)
          .toList();
    }
    return null;
  }

  //  최근 검색어 삭제
  Future<void> deleteRecentSearch(String search) async {
    List<String> currentSearches = await getRecentSearch() ?? [];
    currentSearches.remove(search); // 특정 검색어만 제거
    print("deleteRecentSearch: $currentSearches");
    await write("recentSearches", jsonEncode(currentSearches));
  }

  // 🔹 앱 첫 실행 여부 저장
  Future<void> setIsFirstLaunch(bool isFirst) async {
    await write("isFirstLaunch", isFirst ? "true" : "false");
  }

  // 🔹 앱 첫 실행 여부 확인
  Future<bool?> getIsFirstLaunch() async {
    final value = await _read("isFirstLaunch");
    if (value == null) return true;
    return value == "true";
  }

  // 🔹 amplitude유저 정보 저장
  Future<void> setAmplitudeUserId(String userId) async =>
      write("amplitudeUserId", userId);
  Future<String?> getAmplitudeUserId() async => _read("amplitudeUserId");
}
