import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:giftrip/core/app.dart';
import 'package:giftrip/core/constants/font_manager.dart';
import 'package:giftrip/core/utils/env_config.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // 프레임워크 초기화
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 폰트 로드
    await FontManager.loadPretendardFonts();

    // 환경 변수 로드
    await dotenv.load(fileName: '.env');

    // 환경 변수 디버그 출력
    EnvConfig.printEnvVars();

    // Firebase 초기화
    await Firebase.initializeApp();

    // 앱 실행
    runApp(const MyApp());
  } catch (e, stackTrace) {
    debugPrint("앱 초기화 중 오류 발생: $e");
    debugPrint(stackTrace.toString());
  }
}
