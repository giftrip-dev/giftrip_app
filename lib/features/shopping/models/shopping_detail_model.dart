import 'package:giftrip/features/home/models/product_model.dart';
import 'package:giftrip/features/shopping/models/shopping_category.dart';
import 'package:giftrip/features/shopping/models/shopping_model.dart';

/// 정보 섹션
class InformationSection {
  final String title;
  final String content;

  const InformationSection({
    required this.title,
    required this.content,
  });
}

/// 쇼핑 상품 상세 모델
class ShoppingDetailModel extends ShoppingModel {
  final String location; // 판매처 위치
  final String managerPhoneNumber; // 담당자 연락처
  final String detailImageUrl; // 상세 이미지 URL
  final String croppedDetailImageUrl; // 상세 이미지 URL (크롭된 버전)
  final InformationSection inquiryInfo; // 문의 정보
  final InformationSection changeInfo; // 교환/환불 정보
  final String deliveryInfo; // 배송 정보

  const ShoppingDetailModel({
    required super.id,
    required super.name,
    required super.description,
    required super.content,
    required super.thumbnailUrl,
    required super.originalPrice,
    required super.finalPrice,
    required super.category,
    required super.rating,
    required super.reviewCount,
    required super.manufacturer,
    super.managerPhone,
    super.isSoldOut = false,
    super.isOptionUsed = false,
    super.stockCount,
    super.itemTags = const [],
    super.exposureTags,
    super.relatedLink,
    super.hasDiscount = false,
    super.isAvailableToPurchase = true,
    super.isOrderQuantityLimited = false,
    super.maxOrderQuantity,
    required super.createdAt,
    required super.updatedAt,
    required super.options,
    required this.location,
    required this.managerPhoneNumber,
    required this.detailImageUrl,
    required this.croppedDetailImageUrl,
    required this.inquiryInfo,
    required this.changeInfo,
    required this.deliveryInfo,
  });

  /// JSON -> Shopping Detail Model
  factory ShoppingDetailModel.fromJson(Map<String, dynamic> json) {
    return ShoppingDetailModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      content: json['content'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      originalPrice: json['originalPrice'] as int,
      finalPrice: json['finalPrice'] as int,
      category: ShoppingCategory.fromString(json['category'] as String) ??
          ShoppingCategory.others,
      rating: json['rating'] as String? ?? "0.00",
      reviewCount: json['reviewCount'] as int,
      manufacturer: json['manufacturer'] as String,
      managerPhone: json['managerPhone'] as String?,
      isSoldOut: json['isSoldOut'] as bool? ?? false,
      isOptionUsed: json['isOptionUsed'] as bool? ?? false,
      stockCount: json['stockCount'] as int?,
      itemTags: (json['itemTags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      exposureTags: (json['exposureTags'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      relatedLink: json['relatedLink'] as String?,
      hasDiscount: json['hasDiscount'] as bool? ?? false,
      isAvailableToPurchase: json['isAvailableToPurchase'] as bool? ?? true,
      isOrderQuantityLimited: json['isOrderQuantityLimited'] as bool? ?? false,
      maxOrderQuantity: json['maxOrderQuantity'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => ShoppingOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      location: json['location'] as String? ?? '',
      managerPhoneNumber: json['managerPhoneNumber'] as String? ?? '',
      detailImageUrl: json['detailImageUrl'] as String? ?? '',
      croppedDetailImageUrl: json['croppedDetailImageUrl'] as String? ?? '',
      inquiryInfo: json['inquiryInfo'] != null
          ? InformationSection(
              title: json['inquiryInfo']['title'] as String,
              content: json['inquiryInfo']['content'] as String,
            )
          : const InformationSection(
              title: '문의하기', content: '문의사항이 있으시면 연락 부탁드립니다.'),
      changeInfo: json['changeInfo'] != null
          ? InformationSection(
              title: json['changeInfo']['title'] as String,
              content: json['changeInfo']['content'] as String,
            )
          : const InformationSection(
              title: '교환/환불 안내', content: '교환/환불 관련 안내입니다.'),
      deliveryInfo: json['deliveryInfo'] as String? ?? '배송 정보',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    return {
      ...baseJson,
      'location': location,
      'managerPhoneNumber': managerPhoneNumber,
      'detailImageUrl': detailImageUrl,
      'croppedDetailImageUrl': croppedDetailImageUrl,
      'inquiryInfo': {
        'title': inquiryInfo.title,
        'content': inquiryInfo.content,
      },
      'changeInfo': {
        'title': changeInfo.title,
        'content': changeInfo.content,
      },
      'deliveryInfo': deliveryInfo,
    };
  }
}
