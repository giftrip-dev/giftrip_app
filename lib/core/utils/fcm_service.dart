import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:myong/core/services/storage_service.dart';
import 'package:myong/features/community/screens/community_detail_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:logger/logger.dart';

class FCMService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final GlobalStorage _globalStorage = GlobalStorage();
  final GlobalKey<NavigatorState> navigatorKey;
  final logger = Logger();

  FCMService({required this.navigatorKey});
  Future<void> initializeFCM() async {
    if (Platform.isIOS) {
      // 1. 알림 권한 요청
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        logger.d('authorizationStatus denied');
        return;
      }

      // 2. APNs 토큰 대기 (iOS에서만 의미 있음)
      String? apnsToken;
      int retries = 0;
      while (apnsToken == null && retries < 5) {
        await Future.delayed(Duration(seconds: 1)); // 1초 대기
        apnsToken = await _messaging.getAPNSToken();
        logger.d('⏳ APNs Token (try $retries): $apnsToken');
        retries++;
      }

      if (apnsToken == null) {
        logger.d('❌ Failed to get APNs token.');
        return;
      }
    }
    // 3. FCM 토큰 가져오기
    String? token = await _messaging.getToken();

    if (token != null) {
      logger.d('✅ FCM Token: $token');
      await _globalStorage.setFcmToken(token);
    } else {
      logger.d('❌ Failed to get FCM token.');
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      logger.d("Notification Clicked!");
      logger.d("message.data: ${message.data}");

      var routeParams = jsonDecode(message.data['routeParams']);
      var postId = routeParams['params']['postId'];
      var screen = routeParams['screen'];

      if (screen == 'PostDetail' && navigatorKey.currentState != null) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => CommunityDetailScreen(postId: postId),
            settings: RouteSettings(name: "/community/$postId"),
          ),
        );
      } else {
        debugPrint(
            "The current navigatorState is null or the widget is not mounted.");
      }
    });

    // FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _showForegroundNotification(message);
    });
  }

  // // 백그라운드 메시지 핸들러
  // Future<void> _backgroundHandler(RemoteMessage message) async {
  //   logger.d('Background message received: ${message.notification?.body}');
  // }

  // 로컬 알림 표시 메서드
  Future<void> _showForegroundNotification(RemoteMessage message) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // 알림 초기화
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // 알림 클릭 시 동작
        var routeParams = jsonDecode(message.data['routeParams']);
        var postId = routeParams['params']['postId'];
        var screen = routeParams['screen'];

        if (screen == 'PostDetail' && navigatorKey.currentState != null) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => CommunityDetailScreen(postId: postId),
              settings: RouteSettings(name: "/community/$postId"),
            ),
          );
        } else {
          debugPrint(
              "The current navigatorState is null or the widget is not mounted.");
        }
      },
    );

    // 알림 내용 설정
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('myong_channel', 'myong_app_notification',
            channelDescription: 'myong_app_notification',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // 알림 표시
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );
  }
}
