import 'package:giftrip/core/constants/item_type.dart';

/// 공유 URL 생성 유틸리티
class ShareUrlGenerator {
  // todo: 실제 도메인으로 변경 필요
  static const String _webDomain = 'myong.co.kr';

  // 앱스토어 URL
  static const String _androidAppUrl =
      'https://play.google.com/store/apps/details?id=com.myong.app';
  static const String _iosAppUrl =
      'https://apps.apple.com/app/myong/id123456789';

  /// 웹 URL 생성
  static String generateWebUrl(String itemId, ProductItemType type) {
    final path = switch (type) {
      ProductItemType.product => 'products',
      ProductItemType.lodging => 'lodgings',
      ProductItemType.experience => 'experiences',
      ProductItemType.experienceGroup => 'experience-groups',
    };

    return 'https://$_webDomain/$path/$itemId';
  }

  /// 딥링크 URL 생성
  static String generateDeepLink(String itemId, ProductItemType type) {
    final path = switch (type) {
      ProductItemType.product => 'products',
      ProductItemType.lodging => 'lodgings',
      ProductItemType.experience => 'experiences',
      ProductItemType.experienceGroup => 'experience-groups',
    };

    return 'myong://$path/$itemId';
  }

  /// 앱스토어 URL 생성 (Android/iOS 구분)
  static String getAppStoreUrl(bool isIOS) {
    return isIOS ? _iosAppUrl : _androidAppUrl;
  }

  /// 공유 메시지 생성
  static String generateShareMessage({
    required String title,
    required String itemId,
    required ProductItemType type,
  }) {
    final url = generateWebUrl(itemId, type);
    return '[$title]\n\n자세히 보기 👉 $url';
  }
}
