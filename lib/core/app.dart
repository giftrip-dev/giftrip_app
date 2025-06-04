import 'package:flutter/material.dart';
import 'package:giftrip/core/themes/light_theme.dart';
import 'package:giftrip/core/utils/route_observer.dart';
import 'package:giftrip/features/auth/screens/login_screen.dart';
import 'package:giftrip/features/auth/view_models/auth_view_model.dart';
import 'package:giftrip/features/cart/view_models/cart_view_model.dart';
import 'package:giftrip/features/event/screens/event_screen.dart';
import 'package:giftrip/features/event/view_models/event_view_model.dart';
import 'package:giftrip/features/experience/screens/experience_screen.dart';
import 'package:giftrip/features/experience/view_models/experience_view_model.dart';
import 'package:giftrip/features/lodging/screens/location_screen.dart';
import 'package:giftrip/features/lodging/screens/lodging_screen.dart';
import 'package:giftrip/features/lodging/view_models/lodging_view_model.dart';
import 'package:giftrip/features/home/view_models/product_view_model.dart';
import 'package:giftrip/features/inquiry/screens/inquiry_screen.dart';
import 'package:giftrip/features/leave/view_models/leave_view_model.dart';
import 'package:giftrip/features/notice/view_models/notice_view_model.dart';
import 'package:giftrip/features/shopping/screens/shopping_screen.dart';
import 'package:giftrip/features/shopping/view_models/shopping_view_model.dart';
import 'package:giftrip/features/splash/screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:giftrip/core/services/storage_service.dart';
import 'package:app_links/app_links.dart';
import 'package:giftrip/features/user/view_models/user_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:giftrip/core/utils/fcm_service.dart';
import 'package:giftrip/core/utils/get_device_info.dart';
import 'package:giftrip/features/review/view_models/review_view_model.dart';
import 'package:giftrip/features/payment/view_models/payment_view_model.dart';
import 'package:giftrip/features/order_history/view_models/order_history_view_model.dart';
import 'package:giftrip/features/order_history/screens/order_history_screen.dart';
import 'package:giftrip/features/tester/view_models/tester_view_model.dart';
import 'package:giftrip/features/tester/screens/tester_screen.dart';
import 'package:giftrip/features/delivery/view_models/delivery_view_model.dart';
import 'package:giftrip/features/delivery/screens/delivery_screen.dart';
import 'package:giftrip/features/my/view_models/mypage_view_model.dart';
import 'package:giftrip/features/my/screens/my_page_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _initFirebase();
    // _initDeepLink();
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

  // 딥링크 초기화
  // void _initDeepLink() async {
  //   try {
  //     // 앱이 처음 실행될 때 URL 확인
  //     Uri? initialUri = await _appLinks.getInitialLink();
  //     if (initialUri != null) {
  //       _handleDeepLink(initialUri);
  //     }

  //     // 앱이 실행 중일 때 URL 감지
  //     _appLinks.uriLinkStream.listen((Uri? uri) {
  //       if (uri != null) {
  //         _handleDeepLink(uri);
  //       }
  //     });
  //   } catch (e) {
  //     debugPrint("딥 링크 처리 중 오류 발생: $e");
  //   }
  // }

  // void _handleDeepLink(Uri uri) {
  //   debugPrint("딥 링크 감지됨: $uri");

  //   if (uri.pathSegments.isNotEmpty) {
  //     if (uri.host == 'community' && uri.pathSegments.isNotEmpty) {
  //       String communityId = uri.pathSegments[0];

  //       // navigatorKey를 사용하여 어디서든 페이지 이동 가능
  //       if (navigatorKey.currentState != null && mounted) {
  //         navigatorKey.currentState?.push(
  //           MaterialPageRoute(
  //             builder: (context) => CommunityDetailScreen(postId: communityId),
  //             settings: RouteSettings(name: "/community/$communityId"),
  //           ),
  //         );
  //       } else {
  //         debugPrint("현재 navigatorState가 null이거나 위젯이 마운트되지 않았습니다.");
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FeedbackViewModel()),
        ChangeNotifierProvider(create: (_) => NoticeViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
        ChangeNotifierProvider(create: (_) => EventViewModel()),
        ChangeNotifierProvider(create: (_) => ExperienceViewModel()),
        ChangeNotifierProvider(create: (_) => LodgingViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => ReviewViewModel()),
        ChangeNotifierProvider(create: (_) => ShoppingViewModel()),
        ChangeNotifierProvider(create: (_) => PaymentViewModel()),
        ChangeNotifierProvider(create: (_) => OrderHistoryViewModel()),
        ChangeNotifierProvider(create: (_) => TesterViewModel()),
        ChangeNotifierProvider(create: (_) => DeliveryViewModel()),
        ChangeNotifierProvider(create: (_) => MyPageViewModel()),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            navigatorObservers: [routeObserver],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ko', 'KR'),
              Locale('en', 'US'),
            ],
            locale: const Locale('ko', 'KR'), // 기본 로케일을 한국어로 설정
            debugShowCheckedModeBanner: false,
            title: 'Giftrip',
            theme: lightTheme,
            darkTheme: lightTheme,
            initialRoute: '/splash',
            onGenerateRoute: (settings) {
              final uri = Uri.parse(settings.name ?? "");

              if (uri.pathSegments.isNotEmpty &&
                  uri.pathSegments.first == "community") {
                // if (uri.pathSegments.length > 1) {
                //   // /community/{id} 상세 페이지 처리
                //   final postId = uri.pathSegments[1];
                //   return MaterialPageRoute(
                //     builder: (context) => CommunityDetailScreen(postId: postId),
                //     settings: RouteSettings(name: "/community/$postId"),
                //   );
                // } else {
                //   // /community 목록 페이지 처리
                //   return MaterialPageRoute(
                //     builder: (context) => const CommunityScreen(),
                //     settings: const RouteSettings(name: "/community"),
                //   );
                // }
              }
              return null;
            },

            routes: {
              '/login': (context) => const LoginScreen(),
              '/splash': (context) => const SplashScreen(),
              '/experience': (ctx) => const ExperienceScreen(),
              '/shopping': (ctx) => const ShoppingScreen(),
              '/lodging': (ctx) => const LodgingScreen(),
              '/location': (ctx) => const LocationScreen(),
              '/tester': (ctx) => const TesterScreen(),
              '/event': (ctx) => const EventScreen(),
              '/inquiry': (ctx) => const InquiryScreen(),
              '/order_history': (ctx) => const OrderHistoryScreen(),
              '/delivery': (ctx) => const DeliveryScreen(),
              '/mypage': (ctx) => const MyPageScreen(),
            },
          );
        },
      ),
    );
  }
}
