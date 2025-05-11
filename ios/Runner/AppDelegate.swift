import Flutter
import UIKit
import Foundation
import Firebase
import UserNotifications
import NaverThirdPartyLogin  

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Firebase 초기화
    FirebaseApp.configure()
    print("Firebase configured")


    // 앱 실행 시 사용자에게 알림 허용 권한을 받음
    UNUserNotificationCenter.current().delegate = self
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions,
      completionHandler: {_, _ in })
    
    application.registerForRemoteNotifications()
    Messaging.messaging().delegate = self

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // ✅ 네이버 로그인 인증을 위한 URL 처리 추가
  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    var applicationResult = false

    // Naver Login 처리
    if !applicationResult {
       applicationResult = NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
    }

    // 다른 SDK URL 처리
    if !applicationResult {
       applicationResult = super.application(app, open: url, options: options)
    }
    
    return applicationResult
  }

  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // FCM에 디바이스 토큰 등록
    Messaging.messaging().apnsToken = deviceToken
  }
}

extension AppDelegate {
  override func userNotificationCenter(_ center: UNUserNotificationCenter, 
                                         willPresent notification: UNNotification, 
                                         withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.list, .banner, .sound])
  }
}

// FCM 토큰 관리
extension AppDelegate: MessagingDelegate {
  
  // Firebase 등록 토큰을 받을 때 실행
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase Registration Token: \(String(describing: fcmToken))")

    let dataDict: [String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: dataDict
    )

  }
}
