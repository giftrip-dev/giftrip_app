import 'package:myong/core/enum/community_enum.dart';
import 'package:myong/core/utils/page_meta.dart';
import 'package:myong/features/community/models/comment_model.dart';

class PostModel {
  final List<String> fileUrls;
  final String? thumbnailUrl;
  final BeautyCategory beautyCategory;
  final String title;
  final String content;
  final int viewCount;
  final int likeCount;
  final int commentCount;
  final bool? isAuthor;
  final bool? isLiked;
  final List<CommentModel> comments;
  final String id;
  final String? authorId;
  final DateTime createdAt;
  final DateTime updatedAt;

  PostModel({
    required this.fileUrls,
    required this.beautyCategory,
    required this.title,
    required this.content,
    required this.viewCount,
    required this.likeCount,
    required this.commentCount,
    this.isAuthor,
    this.isLiked,
    this.thumbnailUrl,
    required this.comments,
    required this.id,
    required this.authorId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// copyWith 메서드 (기존 객체 복사하며 특정 필드만 변경하는 메서드)
  PostModel copyWith({
    List<String>? fileUrls,
    BeautyCategory? beautyCategory,
    String? title,
    String? content,
    int? viewCount,
    int? likeCount,
    int? commentCount,
    bool? isAuthor,
    bool? isLiked,
    String? thumbnailUrl,
    List<CommentModel>? comments,
    String? id,
    String? authorId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PostModel(
      fileUrls: fileUrls ?? this.fileUrls,
      beautyCategory: beautyCategory ?? this.beautyCategory,
      title: title ?? this.title,
      content: content ?? this.content,
      viewCount: viewCount ?? this.viewCount,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isAuthor: isAuthor ?? this.isAuthor,
      isLiked: isLiked ?? this.isLiked,
      comments: comments ?? this.comments,
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// JSON 데이터를 Dart 객체로 변환
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      fileUrls: List<String>.from(json['fileUrls'] ?? []),
      beautyCategory: BeautyCategory.fromString(json['beautyCategory']),
      title: json['title'],
      content: json['content'],
      viewCount: json['viewCount'] ?? 0,
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      isAuthor: json['isAuthor'],
      isLiked: json['isLiked'],
      thumbnailUrl: json['thumbnailUrl'],
      comments: (json['comments'] != null && json['comments'] is List)
          ? (json['comments'] as List)
              .map((e) => CommentModel.fromJson(e))
              .toList()
          : [], // comments가 null이거나 비어 있으면 빈 리스트 반환
      id: json['id'],
      authorId: json['authorId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  /// Dart 객체를 JSON 데이터로 변환
  Map<String, dynamic> toJson() {
    return {
      'fileUrls': fileUrls,
      'beautyCategory': BeautyCategory.toUpperString(beautyCategory),
      'title': title,
      'content': content,
      'viewCount': viewCount,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'isAuthor': isAuthor,
      'isLiked': isLiked,
      'thumbnailUrl': thumbnailUrl,
      'comments': comments.map((c) => c.toJson()).toList(),
      'id': id,
      'authorId': authorId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

// 게시글 조회 응답
class PostPageResponse {
  final List<PostModel> items;
  final PageMeta meta;

  PostPageResponse({
    required this.items,
    required this.meta,
  });

  factory PostPageResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>;
    return PostPageResponse(
      items: itemsJson.map((e) => PostModel.fromJson(e)).toList(),
      meta: PageMeta.fromJson(json['meta']),
    );
  }
}
