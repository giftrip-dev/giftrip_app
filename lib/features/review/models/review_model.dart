import 'package:giftrip/core/utils/page_meta.dart';

/// 리뷰 모델
class ReviewModel {
  final String id;
  final String content;
  final double rating;
  final String? thumbnailUrl; // 썸네일은 옵션(없을 수 있음)
  final DateTime createdAt;
  final String userId;
  final String userNickname;

  const ReviewModel({
    required this.id,
    required this.content,
    required this.rating,
    required this.createdAt,
    required this.userId,
    required this.userNickname,
    this.thumbnailUrl,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      content: json['content'] as String,
      rating: (json['rating'] as num).toDouble(),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      userId: json['userId'] as String,
      userNickname: json['userNickname'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'rating': rating,
      'thumbnailUrl': thumbnailUrl,
      'createdAt': createdAt.toIso8601String(),
      'userId': userId,
      'userNickname': userNickname,
    };
  }
}

/// 리뷰 페이지 응답 모델
class ReviewPageResponse {
  final List<ReviewModel> items;
  final PageMeta meta;

  const ReviewPageResponse({
    required this.items,
    required this.meta,
  });

  factory ReviewPageResponse.fromJson(Map<String, dynamic> json) {
    return ReviewPageResponse(
      items: (json['items'] as List)
          .map((item) => ReviewModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      meta: PageMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}
