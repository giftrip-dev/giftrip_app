class DateUtil {
  static String formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return '방금 전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 전';
    } else {
      String year = date.year.toString().substring(2);
      String month = date.month.toString().padLeft(2, '0');
      String day = date.day.toString().padLeft(2, '0');
      return '$year.$month.$day';
    }
  }
}

/// 3자리마다 콤마 삽입
String formatPrice(int value) {
  final str = value.toString();
  final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
  return str.replaceAllMapped(reg, (m) => ',');
}
