import 'package:myong/core/utils/page_meta.dart';

/// 이벤트 상태
enum EventStatus {
  upcoming, // 진행 예정
  ongoing, // 진행 중
  ended, // 종료
}

/// 이벤트 모델
class EventModel {
  final String thumbnailUrl;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  const EventModel({
    required this.thumbnailUrl,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });

  /// JSON -> Event Model
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      thumbnailUrl: json['thumbnailUrl'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool,
    );
  }

  /// Event -> JSON
  Map<String, dynamic> toJson() {
    return {
      'thumbnailUrl': thumbnailUrl,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
    };
  }
}

/// 페이징 응답
class EventPageResponse {
  final List<EventModel> items;
  final PageMeta meta;

  EventPageResponse({
    required this.items,
    required this.meta,
  });

  factory EventPageResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>;
    return EventPageResponse(
      items: itemsJson.map((e) => EventModel.fromJson(e)).toList(),
      meta: PageMeta.fromJson(json['meta']),
    );
  }
}
