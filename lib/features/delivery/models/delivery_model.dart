import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/delivery/models/delivery_status.dart';

/// 체험 상품 모델
class DeliveryModel {
  final String id;
  final String title;
  final String thumbnailUrl;
  final int originalPrice;
  final int finalPrice;
  final DeliveryStatus deliveryStatus;
  final DateTime paidAt;
  final String option;
  final int quantity;

  const DeliveryModel({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.originalPrice,
    required this.finalPrice,
    required this.deliveryStatus,
    required this.paidAt,
    required this.option,
    required this.quantity,
  });

  /// JSON -> Experience Model
  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      originalPrice: json['originalPrice'] as int,
      finalPrice: json['finalPrice'] as int,
      deliveryStatus: DeliveryStatus.fromString(json['status'] as String) ??
          DeliveryStatus.preparing,
      paidAt: DateTime.parse(json['paidAt'] as String),
      option: json['option'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  /// Experience -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'originalPrice': originalPrice,
      'finalPrice': finalPrice,
      'status': deliveryStatus.name,
      'paidAt': paidAt.toIso8601String(),
      'option': option,
      'quantity': quantity,
    };
  }
}

/// 페이징 응답
class DeliveryPageResponse {
  final List<DeliveryModel> items;
  final PageMeta meta;

  DeliveryPageResponse({
    required this.items,
    required this.meta,
  });

  factory DeliveryPageResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>;
    return DeliveryPageResponse(
      items: itemsJson.map((e) => DeliveryModel.fromJson(e)).toList(),
      meta: PageMeta.fromJson(json['meta']),
    );
  }
}
