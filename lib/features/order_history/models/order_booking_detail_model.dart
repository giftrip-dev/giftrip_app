import 'package:giftrip/features/order_history/models/order_history_model.dart';

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
class OrderBookingDetailModel extends OrderHistoryModel {
  final String location;
  final String managerPhoneNumber;
  final String reserverName;
  final String reserverPhoneNumber;
  final String payMethod;
  final String? deliveryAddress;
  final String? deliveryDetail;

  const OrderBookingDetailModel({
    required super.id,
    required super.orderName,
    required super.items,
    required super.totalAmount,
    required super.progress,
    required super.paidAt,
    required super.transactionId,
    required this.location,
    required this.managerPhoneNumber,
    required this.reserverName,
    required this.reserverPhoneNumber,
    required this.payMethod,
    this.deliveryAddress,
    this.deliveryDetail,
  });

  factory OrderBookingDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderBookingDetailModel(
      id: json['id'] as String,
      orderName: json['orderName'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderHistoryItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: json['totalAmount'] as int,
      progress: OrderBookingProgress.values.firstWhere(
        (e) => e.name == json['progress'],
        orElse: () => OrderBookingProgress.confirmed,
      ),
      paidAt: DateTime.parse(json['paidAt'] as String),
      location: json['location'] as String,
      managerPhoneNumber: json['managerPhoneNumber'] as String,
      reserverName: json['reserverName'] as String,
      reserverPhoneNumber: json['reserverPhoneNumber'] as String,
      payMethod: json['payMethod'] as String,
      transactionId: json['transactionId'] as String,
      deliveryAddress: json['deliveryAddress'] as String?,
      deliveryDetail: json['deliveryDetail'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    return {
      ...baseJson,
      'location': location,
      'managerPhoneNumber': managerPhoneNumber,
      'reserverName': reserverName,
      'reserverPhoneNumber': reserverPhoneNumber,
      'payMethod': payMethod,
      'transactionId': transactionId,
    };
  }
}
