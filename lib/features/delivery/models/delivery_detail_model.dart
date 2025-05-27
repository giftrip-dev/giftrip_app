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
class DeliveryDetailModel {
  final String id;
  // 배송 정보
  final String deliveryNumber;
  final DeliveryStatus deliveryStatus;
  final String product;
  final int shippingFee;
  final String invoiceNumber;

  // 주문자 정보
  final String ordererName;
  final String ordererPhone;
  final String ordererEmail;

  // 배송지 정보
  final String recipientName;
  final String recipientPhone;
  final String address;
  final String addressDetail;

  const DeliveryDetailModel({
    required this.id,
    required this.deliveryNumber,
    required this.deliveryStatus,
    required this.product,
    required this.shippingFee,
    required this.invoiceNumber,
    required this.ordererName,
    required this.ordererPhone,
    required this.ordererEmail,
    required this.recipientName,
    required this.recipientPhone,
    required this.address,
    required this.addressDetail,
  });

  factory DeliveryDetailModel.fromJson(Map<String, dynamic> json) {
    return DeliveryDetailModel(
      id: json['id'] as String,
      deliveryNumber: json['deliveryNumber'] as String,
      deliveryStatus:
          DeliveryStatus.fromString(json['deliveryStatus'] as String) ??
              DeliveryStatus.preparing,
      product: json['product'] as String,
      shippingFee: json['shippingFee'] as int,
      invoiceNumber: json['invoiceNumber'] as String,
      ordererName: json['ordererName'] as String,
      ordererPhone: json['ordererPhone'] as String,
      ordererEmail: json['ordererEmail'] as String,
      recipientName: json['recipientName'] as String,
      recipientPhone: json['recipientPhone'] as String,
      address: json['address'] as String,
      addressDetail: json['addressDetail'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deliveryNumber': deliveryNumber,
      'deliveryStatus': deliveryStatus.name,
      'product': product,
      'shippingFee': shippingFee,
      'invoiceNumber': invoiceNumber,
      'ordererName': ordererName,
      'ordererPhone': ordererPhone,
      'ordererEmail': ordererEmail,
      'recipientName': recipientName,
      'recipientPhone': recipientPhone,
      'address': address,
      'addressDetail': addressDetail,
    };
  }
}
