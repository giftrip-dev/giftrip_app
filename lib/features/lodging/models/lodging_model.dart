import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/lodging/models/lodging_category.dart';
import 'package:giftrip/features/lodging/models/location.dart';

/// 숙소 상품 모델
class LodgingModel {
  final String id;
  final String name;
  final LodgingCategory category;
  final MainLocation mainLocation;
  final String subLocation;
  final String address1;
  final String address2;
  final String postalCode;
  final String managerName;
  final String managerPhoneNumber;
  final String thumbnailUrl;
  final String? relatedLink;
  final List<String> itemTags;
  final String? itemMemo;
  final int cheapestOriginalPrice;
  final int cheapestFinalPrice;
  final int cheapestDiscountRate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LodgingModel({
    required this.id,
    required this.name,
    required this.category,
    required this.mainLocation,
    required this.subLocation,
    required this.address1,
    required this.address2,
    required this.postalCode,
    required this.managerName,
    required this.managerPhoneNumber,
    required this.thumbnailUrl,
    this.relatedLink,
    this.itemTags = const [],
    this.itemMemo,
    required this.cheapestOriginalPrice,
    required this.cheapestFinalPrice,
    required this.cheapestDiscountRate,
    required this.createdAt,
    required this.updatedAt,
  });

  /// JSON -> Lodging Model
  factory LodgingModel.fromJson(Map<String, dynamic> json) {
    return LodgingModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: LodgingCategory.fromString(json['category'] as String) ??
          LodgingCategory.hotel,
      mainLocation: MainLocation.values.firstWhere(
        (location) => location.name == json['mainLocation'],
      ),
      subLocation: json['subLocation'] as String,
      address1: json['address1'] as String,
      address2: json['address2'] as String,
      postalCode: json['postalCode'] as String,
      managerName: json['managerName'] as String,
      managerPhoneNumber: json['managerPhoneNumber'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      relatedLink: json['relatedLink'] as String?,
      itemTags: (json['itemTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      itemMemo: json['itemMemo'] as String?,
      cheapestOriginalPrice: json['cheapestOriginalPrice'] as int,
      cheapestFinalPrice: json['cheapestFinalPrice'] as int,
      cheapestDiscountRate: json['cheapestDiscountRate'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Lodging -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.name,
      'mainLocation': mainLocation,
      'subLocation': subLocation,
      'address1': address1,
      'address2': address2,
      'postalCode': postalCode,
      'managerName': managerName,
      'managerPhoneNumber': managerPhoneNumber,
      'thumbnailUrl': thumbnailUrl,
      'relatedLink': relatedLink,
      'itemTags': itemTags,
      'itemMemo': itemMemo,
      'cheapestOriginalPrice': cheapestOriginalPrice,
      'cheapestFinalPrice': cheapestFinalPrice,
      'cheapestDiscountRate': cheapestDiscountRate,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/// 페이징 응답
class LodgingPageResponse {
  final List<LodgingModel> items;
  final PageMeta meta;

  LodgingPageResponse({
    required this.items,
    required this.meta,
  });

  factory LodgingPageResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>;
    return LodgingPageResponse(
      items: itemsJson.map((e) => LodgingModel.fromJson(e)).toList(),
      meta: PageMeta.fromJson(json['meta']),
    );
  }
}
