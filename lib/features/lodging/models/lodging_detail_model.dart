import 'package:giftrip/features/lodging/models/lodging_model.dart';
import 'package:giftrip/features/lodging/models/location.dart';
import 'package:giftrip/features/lodging/models/lodging_category.dart';

/// 숙소 상품 상세 모델
class LodgingDetailModel extends LodgingModel {
  const LodgingDetailModel({
    required super.id,
    required super.name,
    required super.category,
    required super.mainLocation,
    required super.subLocation,
    required super.address1,
    required super.address2,
    required super.postalCode,
    required super.managerName,
    required super.managerPhoneNumber,
    required super.thumbnailUrl,
    required super.relatedLink,
    required super.cheapestOriginalPrice,
    required super.cheapestFinalPrice,
    required super.cheapestDiscountRate,
    required super.createdAt,
    required super.updatedAt,
  });

  factory LodgingDetailModel.fromJson(Map<String, dynamic> json) {
    return LodgingDetailModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: LodgingCategory.fromString(json['category'] as String) ??
          LodgingCategory.hotel,
      mainLocation: MainLocation.values.firstWhere(
        (location) => location.label == json['mainLocation'],
      ),
      subLocation: json['subLocation'] as String,
      address1: json['address1'] as String,
      address2: json['address2'] as String,
      postalCode: json['postalCode'] as String,
      managerName: json['managerName'] as String,
      managerPhoneNumber: json['managerPhoneNumber'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      relatedLink: json['relatedLink'] as String,
      cheapestOriginalPrice: json['cheapestOriginalPrice'] as int,
      cheapestFinalPrice: json['cheapestFinalPrice'] as int,
      cheapestDiscountRate: json['cheapestDiscountRate'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }
}
