import 'package:intl/intl.dart';

/// 형식 변환 유틸리티
class Formatters {
  /// 가격 포맷팅: 10000 -> ₩10,000
  static String formatPrice(int price) {
    final formatter = NumberFormat.currency(
      locale: 'ko_KR',
      symbol: '₩',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }

  /// 퍼센트 포맷팅: 0.1 -> 10%
  static String formatPercent(double percent) {
    return '${(percent * 100).toStringAsFixed(0)}%';
  }
}
