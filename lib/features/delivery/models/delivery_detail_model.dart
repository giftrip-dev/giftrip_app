import 'package:giftrip/features/delivery/models/delivery_status.dart';
import 'package:giftrip/features/delivery/models/delivery_model.dart';

/// 문의/변경 정보 모델
class InformationSection {
  final String title;
  final String content;

  const InformationSection({
    required this.title,
    required this.content,
  });

  factory InformationSection.fromJson(Map<String, dynamic> json) {
    return InformationSection(
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }
}

/// 예약 가능 기간 모델
class AvailablePeriod {
  final DateTime startDate;
  final DateTime endDate;

  const AvailablePeriod({
    required this.startDate,
    required this.endDate,
  });

  factory AvailablePeriod.fromJson(Map<String, dynamic> json) {
    return AvailablePeriod(
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}

/// 체험 상품 상세 모델
class DeliveryDetailModel extends DeliveryModel {
  final String location;
  final String managerPhoneNumber;
  final String reserverName;
  final String reserverPhoneNumber;
  final String payMethod;
  final String? deliveryAddress;
  final String? deliveryDetail;

  const DeliveryDetailModel({
    required super.id,
    required super.title,
    required super.thumbnailUrl,
    required super.originalPrice,
    required super.finalPrice,
    required super.status,
    required super.rating,
    required super.reviewCount,
    required super.availableFrom,
    required super.availableTo,
    required super.option,
    required super.quantity,
    required this.location,
    required this.managerPhoneNumber,
    required this.reserverName,
    required this.reserverPhoneNumber,
    required this.payMethod,
    super.discountRate,
    super.soldOut,
    super.unavailableDates,
    required super.paidAt,
    this.deliveryAddress,
    this.deliveryDetail,
  });

  factory DeliveryDetailModel.fromJson(Map<String, dynamic> json) {
    return DeliveryDetailModel(
      id: json['id'] as String,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      originalPrice: json['originalPrice'] as int,
      finalPrice: json['finalPrice'] as int,
      status: DeliveryStatus.fromString(json['status'] as String) ??
          DeliveryStatus.preparing,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      availableFrom: DateTime.parse(json['availableFrom'] as String),
      availableTo: DateTime.parse(json['availableTo'] as String),
      soldOut: json['soldOut'] as bool? ?? false,
      unavailableDates: (json['unavailableDates'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      discountRate: json['discountRate'] as int?,
      paidAt: DateTime.parse(json['paidAt'] as String),
      option: json['option'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
      location: json['location'] as String,
      managerPhoneNumber: json['managerPhoneNumber'] as String,
      reserverName: json['reserverName'] as String,
      reserverPhoneNumber: json['reserverPhoneNumber'] as String,
      payMethod: json['payMethod'] as String,
      deliveryAddress: json['deliveryAddress'] as String?,
      deliveryDetail: json['deliveryDetail'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'managerPhoneNumber': managerPhoneNumber,
      'reserverName': reserverName,
      'reserverPhoneNumber': reserverPhoneNumber,
      'payMethod': payMethod,
    };
  }
}
