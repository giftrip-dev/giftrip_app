import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 환경 변수 관리 클래스
class EnvConfig {
  /// API 베이스 URL
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.giftrip.co.kr';

  /// API 버전
  static String get apiVersion => dotenv.env['API_VERSION'] ?? 'v1';

  /// 디버그 모드 여부
  static bool get isDebug {
    final debugValue = dotenv.env['DEBUG']?.toLowerCase();
    return debugValue == 'true' || debugValue == '1' || debugValue == 'yes';
  }

  /// 앱 이름
  static String get appName => dotenv.env['APP_NAME'] ?? 'Giftrip';

  /// Firebase 프로젝트 ID
  static String get firebaseProjectId =>
      dotenv.env['FIREBASE_PROJECT_ID'] ?? '';

  /// Firebase API 키
  static String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';

  /// Toss 클라이언트 키
  static String get tossClientKey => dotenv.env['TOSS_CLIENT_KEY'] ?? '';

  /// 전체 API URL 조합
  static String get fullApiUrl => '$apiBaseUrl/$apiVersion';

  /// 환경 변수 값 가져오기 (기본값 포함)
  static String getValue(String key, {String defaultValue = ''}) {
    return dotenv.env[key] ?? defaultValue;
  }

  /// 환경 변수 디버그 출력
  static void printEnvVars() {
    if (isDebug) {
      print('=== Environment Variables ===');
      print('API_BASE_URL: $apiBaseUrl');
      print('API_VERSION: $apiVersion');
      print('DEBUG: $isDebug');
      print('APP_NAME: $appName');
      print('FULL_API_URL: $fullApiUrl');
      print('=============================');
    }
  }
}
