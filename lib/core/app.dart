import 'package:flutter/material.dart';
import 'package:myong/core/themes/light_theme.dart';
import 'package:myong/core/utils/route_observer.dart';
import 'package:myong/features/auth/screens/login_screen.dart';
import 'package:myong/features/auth/view_models/auth_view_model.dart';
import 'package:myong/features/community/screens/community_detail_screen.dart';
import 'package:myong/features/community/screens/community_screen.dart';
import 'package:myong/features/community/view_models/comment_view_model.dart';
import 'package:myong/features/community/view_models/community_search_view_model.dart';
import 'package:myong/features/community/view_models/community_view_model.dart';
import 'package:myong/features/community/view_models/community_write_view_model.dart';
import 'package:myong/features/leave/view_models/leave_view_model.dart';
import 'package:myong/features/my/view_models/my_community_view_model.dart';
import 'package:myong/features/notice/view_models/notice_view_model.dart';
import 'package:myong/features/splash/screen/splash_screen.dart';
import 'package:myong/features/user/view_models/certificate_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:myong/core/services/storage_service.dart';
import 'package:app_links/app_links.dart';
import 'package:myong/features/user/view_models/user_view_model.dart';
import 'package:myong/features/notification/view_models/notification_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myong/core/utils/fcm_service.dart';
import 'package:myong/core/utils/get_device_info.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/configuration.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';

// 전역 navigatorKey 설정 (DioClient에서도 사용 가능)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FCMService _fcmService = FCMService(navigatorKey: navigatorKey);
  final AppLinks _appLinks = AppLinks();
  final Amplitude _amplitude = Amplitude(Configuration(
    apiKey: dotenv.maybeGet('AMPLITUDE_API_KEY') ?? '',
  ));

  @override
  void initState() {
    super.initState();
    _initFirebase();
    _initDeepLink();
    _initAmplitude();
    // notificationPermissionSelected가 false일 때만 권한 요청
    GlobalStorage().getNotificationPermissionSelected().then((isSelected) {
      if (!isSelected) {
        GlobalStorage().requestNotificationPermission();
      }
    });

    print("initialized app");
  }

  void _initFirebase() async {
    await Firebase.initializeApp();
    await _fcmService.initializeFCM();
    await getDeviceInfo();
  }

  void _initAmplitude() async {
    // 기존 amplitudeUserId 확인
    final storage = GlobalStorage();
    String? existingUserId = await storage.getAmplitudeUserId();

    if (existingUserId == null) {
      // UUID를 사용하여 고유 ID 생성
      String newUserId = Uuid().v4();
      await storage.setAmplitudeUserId(newUserId);
    }

    await _amplitude.isBuilt;
  }

  // 딥링크 초기화
  void _initDeepLink() async {
    try {
      // 앱이 처음 실행될 때 URL 확인
      Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }

      // 앱이 실행 중일 때 URL 감지
      _appLinks.uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          _handleDeepLink(uri);
        }
      });
    } catch (e) {
      debugPrint("딥 링크 처리 중 오류 발생: $e");
    }
  }

  void _handleDeepLink(Uri uri) {
    debugPrint("딥 링크 감지됨: $uri");

    if (uri.pathSegments.isNotEmpty) {
      if (uri.host == 'community' && uri.pathSegments.isNotEmpty) {
        String communityId = uri.pathSegments[0];

        // navigatorKey를 사용하여 어디서든 페이지 이동 가능
        if (navigatorKey.currentState != null && mounted) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => CommunityDetailScreen(postId: communityId),
              settings: RouteSettings(name: "/community/$communityId"),
            ),
          );
        } else {
          debugPrint("현재 navigatorState가 null이거나 위젯이 마운트되지 않았습니다.");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CertificateViewModel()),
        ChangeNotifierProvider(create: (_) => CommunityViewModel()),
        ChangeNotifierProvider(create: (_) => CommunitySearchViewModel()),
        ChangeNotifierProvider(create: (_) => CommunityWriteViewModel()),
        ChangeNotifierProvider(create: (_) => MyCommunityViewModel()),
        ChangeNotifierProvider(create: (_) => FeedbackViewModel()),
        ChangeNotifierProvider(create: (_) => CommentViewModel()),
        ChangeNotifierProvider(create: (_) => NoticeViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: Builder(
        builder: (context) {
          // 앱 시작 시 알림 권한 요청
          // GlobalStorage().requestNotificationPermission();

          return MaterialApp(
            navigatorKey: navigatorKey,
            navigatorObservers: [routeObserver],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('ko', ''),
            ],
            debugShowCheckedModeBanner: false,
            title: 'My App',
            theme: lightTheme,
            darkTheme: lightTheme,
            // themeMode: ThemeMode.system,
            initialRoute: '/splash',
            onGenerateRoute: (settings) {
              final uri = Uri.parse(settings.name ?? "");

              if (uri.pathSegments.isNotEmpty &&
                  uri.pathSegments.first == "community") {
                if (uri.pathSegments.length > 1) {
                  // /community/{id} 상세 페이지 처리
                  final postId = uri.pathSegments[1];
                  return MaterialPageRoute(
                    builder: (context) => CommunityDetailScreen(postId: postId),
                    settings: RouteSettings(name: "/community/$postId"),
                  );
                } else {
                  // /community 목록 페이지 처리
                  return MaterialPageRoute(
                    builder: (context) => const CommunityScreen(),
                    settings: const RouteSettings(name: "/community"),
                  );
                }
              }
              return null;
            },

            routes: {
              '/login': (context) => const LoginScreen(),
              '/splash': (context) => const SplashScreen(),
            },
          );
        },
      ),
    );
  }
}
