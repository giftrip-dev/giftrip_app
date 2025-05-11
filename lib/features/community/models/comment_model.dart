// 댓글 모델
class CommentModel {
  final String id;
  String content;
  final String? parentId;
  final String? anonymousId;
  final String? mentionUserId;
  final String userId;
  final DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;
  final bool isAuthor;
  final List<CommentModel> replies;

  CommentModel({
    required this.id,
    required this.content,
    this.parentId,
    this.anonymousId,
    this.mentionUserId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.isAuthor,
    required this.replies,
  });

  /// JSON 데이터를 Dart 객체로 변환
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      parentId: json['parentId'],
      anonymousId: json['anonymousId'],
      mentionUserId: json['mentionUserId'],
      userId: json['userId'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      isAuthor: json['isAuthor'] ?? false,
      replies: (json['replies'] != null && json['replies'] is List)
          ? (json['replies'] as List)
              .whereType<Map<String, dynamic>>() // 리스트 내 요소가 Map인지 확인
              .map((e) => CommentModel.fromJson(e)) // 재귀적으로 CommentModel로 변환
              .toList()
          : [],
    );
  }

  /// Dart 객체를 JSON 데이터로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'parentId': parentId,
      'anonymousId': anonymousId,
      'mentionUserId': mentionUserId,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'isAuthor': isAuthor,
      'replies': replies.map((c) => c.toJson()).toList(),
    };
  }
}
