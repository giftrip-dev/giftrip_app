import 'package:giftrip/core/utils/page_meta.dart';

class NoticeModel {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final String? imageUrl;

  NoticeModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.imageUrl,
  });

  /// JSON 데이터를 Dart 객체로 변환
  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      imageUrl: json['imageUrl'],
    );
  }

  /// Dart 객체를 JSON 데이터로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }
}

// 게시글 조회 응답
class NoticeResponse {
  final List<NoticeModel> items;
  final PageMeta meta;

  NoticeResponse({
    required this.items,
    required this.meta,
  });

  factory NoticeResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>;
    return NoticeResponse(
      items: itemsJson.map((e) => NoticeModel.fromJson(e)).toList(),
      meta: PageMeta.fromJson(json['meta']),
    );
  }
}
