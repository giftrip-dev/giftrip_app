import 'package:flutter/services.dart';

class FontManager {
  static bool _isLoaded = false;

  static Future<void> loadPretendardFonts() async {
    if (_isLoaded) return;

    final mediumData = rootBundle.load('assets/fonts/Pretendard-Medium.woff');
    final regularData = rootBundle.load('assets/fonts/Pretendard-Regular.woff');
    final boldData = rootBundle.load('assets/fonts/Pretendard-Bold.woff');
    final semiBoldData =
        rootBundle.load('assets/fonts/Pretendard-SemiBold.woff');
    final extraBoldData =
        rootBundle.load('assets/fonts/Pretendard-ExtraBold.woff');

    // 단일 FontLoader에 addFont
    final fontLoader = FontLoader('Pretendard');
    fontLoader.addFont(
      mediumData.then((data) => _byteDataView(data)),
    );
    fontLoader.addFont(
      regularData.then((data) => _byteDataView(data)),
    );
    fontLoader.addFont(
      boldData.then((data) => _byteDataView(data)),
    );
    fontLoader.addFont(
      semiBoldData.then((data) => _byteDataView(data)),
    );
    fontLoader.addFont(
      extraBoldData.then((data) => _byteDataView(data)),
    );

    // 3) 실제 로딩
    await fontLoader.load();
    _isLoaded = true;
  }

  /// rootBundle.load(...) 결과(ByteData)를 Uint8List로 변환해주는 헬퍼
  static ByteData _byteDataView(ByteData data) {
    final bytes = data.buffer.asUint8List();
    return ByteData.view(Uint8List.fromList(bytes).buffer);
  }
}
