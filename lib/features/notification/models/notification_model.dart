class RouteParams {
  final String screen;
  final Map<String, dynamic> params;

  RouteParams({
    required this.screen,
    required this.params,
  });

  /// JSON 데이터를 Dart 객체로 변환
  factory RouteParams.fromJson(Map<String, dynamic> json) {
    return RouteParams(
      screen: json['screen'] ?? '',
      params: json['params'] ?? {},
    );
  }

  /// Dart 객체를 JSON 데이터로 변환
  Map<String, dynamic> toJson() {
    return {
      'screen': screen,
      'params': params,
    };
  }
}

class NotificationModel {
  final RouteParams routeParams;
  final String id;
  final String action;
  final String title;
  final String body;
  final String targetId;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;
  final String? expiresAt;

  NotificationModel({
    required this.routeParams,
    required this.id,
    required this.action,
    required this.title,
    required this.body,
    required this.targetId,
    required this.isRead,
    required this.createdAt,
    this.readAt,
    this.expiresAt,
  });

  /// JSON 데이터를 Dart 객체로 변환
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      routeParams:
          RouteParams.fromJson(json['routeParams'] as Map<String, dynamic>),
      id: json['id'] ?? '',
      action: json['action'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      targetId: json['targetId'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
      expiresAt: json['expiresAt'],
    );
  }

  /// Dart 객체를 JSON 데이터로 변환
  Map<String, dynamic> toJson() {
    return {
      'routeParams': routeParams.toJson(),
      'id': id,
      'action': action,
      'title': title,
      'body': body,
      'targetId': targetId,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
      'expiresAt': expiresAt,
    };
  }
}

class NotificationResponse {
  final List<NotificationModel> items;

  NotificationResponse({required this.items});

  factory NotificationResponse.fromJson(List<dynamic> jsonList) {
    return NotificationResponse(
      items: jsonList
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class FCMTokenModel {
  final String token;
  final String deviceId;
  final String deviceModel;

  FCMTokenModel({
    required this.token,
    required this.deviceId,
    required this.deviceModel,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'deviceId': deviceId,
      'deviceModel': deviceModel,
    };
  }
}
