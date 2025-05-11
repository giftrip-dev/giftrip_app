class ReportDto {
  final String reason; // 신고 사유 (1~6)
  final String detail; // 상세 내용
  final String targetId; // 신고 대상 ID
  final String targetType; // "POST" 또는 "COMMENT"

  ReportDto({
    required this.reason,
    required this.detail,
    required this.targetId,
    required this.targetType,
  });

  Map<String, dynamic> toJson() {
    return {
      "reason": reason,
      "detail": detail,
      "targetId": targetId,
      "targetType": targetType,
    };
  }
}
