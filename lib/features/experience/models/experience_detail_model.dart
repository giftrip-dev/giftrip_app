import 'package:giftrip/features/experience/models/experience_category.dart';
import 'package:giftrip/features/experience/models/experience_model.dart';
import 'package:giftrip/features/home/models/product_model.dart';

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
class ExperienceDetailModel extends ExperienceModel {
  final String thumbnailUrl;
  final String location;
  final String managerPhoneNumber;
  final String? relatedLink;
  final String detailImageUrl;
  final String croppedDetailImageUrl;
  final InformationSection inquiryInfo;
  final InformationSection changeInfo;
  final AvailablePeriod availablePeriod;
  final int durationInDays;

  const ExperienceDetailModel({
    required super.id,
    required super.title,
    required super.description,
    required super.originalPrice,
    required super.finalPrice,
    required super.category,
    required super.rating,
    required super.reviewCount,
    required super.badges,
    required super.availableFrom,
    required super.availableTo,
    required this.thumbnailUrl,
    required this.location,
    required this.managerPhoneNumber,
    required this.detailImageUrl,
    required this.croppedDetailImageUrl,
    required this.inquiryInfo,
    required this.changeInfo,
    required this.availablePeriod,
    required this.durationInDays,
    this.relatedLink,
    super.discountRate,
  }) : super(thumbnailUrl: thumbnailUrl);

  factory ExperienceDetailModel.fromJson(Map<String, dynamic> json) {
    final availablePeriod = AvailablePeriod.fromJson(
        json['availablePeriod'] as Map<String, dynamic>);

    return ExperienceDetailModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      originalPrice: json['originalPrice'] as int,
      finalPrice: json['finalPrice'] as int,
      category: ExperienceCategory.fromString(json['category'] as String) ??
          ExperienceCategory.food,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      badges: (json['badges'] as List<dynamic>?)
              ?.map((e) => ProductTagType.values.firstWhere(
                    (type) => type.name == e.toString().toUpperCase(),
                    orElse: () => ProductTagType.newArrival,
                  ))
              .toList() ??
          [],
      availableFrom: availablePeriod.startDate,
      availableTo: availablePeriod.endDate,
      discountRate: json['discountRate'] as int?,
      location: json['location'] as String,
      managerPhoneNumber: json['managerPhoneNumber'] as String,
      relatedLink: json['relatedLink'] as String?,
      detailImageUrl: json['detailImageUrl'] as String,
      croppedDetailImageUrl: json['croppedDetailImageUrl'] as String,
      inquiryInfo: InformationSection.fromJson(
          json['inquiryInfo'] as Map<String, dynamic>),
      changeInfo: InformationSection.fromJson(
          json['changeInfo'] as Map<String, dynamic>),
      availablePeriod: availablePeriod,
      durationInDays: json['durationInDays'] as int,
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
      'inquiryInfo': inquiryInfo.toJson(),
      'changeInfo': changeInfo.toJson(),
      'availablePeriod': availablePeriod.toJson(),
      'durationInDays': durationInDays,
    };
  }
}
