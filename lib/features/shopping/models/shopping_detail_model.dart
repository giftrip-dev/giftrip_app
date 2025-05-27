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
  final String relatedLink; // 관련 링크
  final String detailImageUrl; // 상세 이미지 URL
  final String croppedDetailImageUrl; // 상세 이미지 URL (크롭된 버전)
  final InformationSection inquiryInfo; // 문의 정보
  final InformationSection changeInfo; // 교환/환불 정보
  final String deliveryInfo; // 배송 정보

  const ShoppingDetailModel({
    required super.id,
    required super.title,
    required super.description,
    required super.thumbnailUrl,
    required super.originalPrice,
    required super.finalPrice,
    required super.category,
    required super.rating,
    required super.averageRating,
    required super.reviewCount,
    required super.manufacturer,
    required this.location,
    required this.managerPhoneNumber,
    required this.relatedLink,
    required this.detailImageUrl,
    required this.croppedDetailImageUrl,
    required this.inquiryInfo,
    required this.changeInfo,
    required this.deliveryInfo,
    required super.options,
    super.badges = const [],
    super.discountRate,
    super.soldOut = false,
  });

  /// JSON -> Shopping Detail Model
  factory ShoppingDetailModel.fromJson(Map<String, dynamic> json) {
    return ShoppingDetailModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      originalPrice: json['originalPrice'] as int,
      finalPrice: json['finalPrice'] as int,
      category: ShoppingCategory.fromString(json['category'] as String) ??
          ShoppingCategory.others,
      rating: (json['rating'] as num).toDouble(),
      averageRating: (json['averageRating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      discountRate: json['discountRate'] as int?,
      badges: (json['badges'] as List<dynamic>?)
              ?.map((e) => ProductTagType.values.firstWhere(
                    (type) => type.name == e.toString().toUpperCase(),
                    orElse: () => ProductTagType.newArrival,
                  ))
              .toList() ??
          [],
      manufacturer: json['manufacturer'] as String,
      soldOut: json['soldOut'] as bool? ?? false,
      location: json['location'] as String,
      managerPhoneNumber: json['managerPhoneNumber'] as String,
      relatedLink: json['relatedLink'] as String,
      detailImageUrl: json['detailImageUrl'] as String,
      croppedDetailImageUrl: json['croppedDetailImageUrl'] as String,
      inquiryInfo: InformationSection(
        title: json['inquiryInfo']['title'] as String,
        content: json['inquiryInfo']['content'] as String,
      ),
      changeInfo: InformationSection(
        title: json['changeInfo']['title'] as String,
        content: json['changeInfo']['content'] as String,
      ),
      deliveryInfo: json['deliveryInfo'] as String,
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => ShoppingOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    return {
      ...baseJson,
      'location': location,
      'managerPhoneNumber': managerPhoneNumber,
      'relatedLink': relatedLink,
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
