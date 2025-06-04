import 'package:giftrip/core/utils/logger.dart';

/// 전화번호 포맷팅 유틸리티
///
/// 입력된 전화번호 문자열을 포맷팅하여 반환합니다.
/// - 11자리 (휴대폰): 000-0000-0000
/// - 10자리 (일반 전화): 00-0000-0000
/// - 8자리 (지역번호 없음): 0000-0000
///
/// 포맷팅이 불가능한 경우 원본 문자열을 반환합니다.
String formatPhoneNumber(String phone) {
  // 숫자만 추출
  String numbers = phone.replaceAll(RegExp(r'[^0-9]'), '');

  try {
    if (numbers.length == 11) {
      // 휴대폰 번호
      return '${numbers.substring(0, 3)}-${numbers.substring(3, 7)}-${numbers.substring(7)}';
    } else if (numbers.length == 10) {
      // 일반 전화번호
      return '${numbers.substring(0, 2)}-${numbers.substring(2, 6)}-${numbers.substring(6)}';
    } else if (numbers.length == 8) {
      // 지역번호 없는 전화번호
      return '${numbers.substring(0, 4)}-${numbers.substring(4)}';
    }
  } catch (e) {
    logger.e('전화번호 포맷팅 실패: $e');
  }

  return phone; // 포맷팅 불가능한 경우 원본 반환
}
