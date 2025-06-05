import 'package:flutter/foundation.dart';

class LodgingRoomModel {
  final String accommodationId;
  final String name;
  final List<String> itemTags;
  final String checkInTime;
  final String checkOutTime;
  final DateTime availableFrom;
  final DateTime availableTo;
  final int maxOccupancy;
  final List<String> imageUrls;
  final int originalPrice;
  final int finalPrice;
  final int dailyStock;
  final bool isActive;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LodgingRoomModel({
    required this.accommodationId,
    required this.name,
    required this.itemTags,
    required this.checkInTime,
    required this.checkOutTime,
    required this.availableFrom,
    required this.availableTo,
    required this.maxOccupancy,
    required this.imageUrls,
    required this.originalPrice,
    required this.finalPrice,
    required this.dailyStock,
    required this.isActive,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  factory LodgingRoomModel.fromJson(Map<String, dynamic> json) {
    return LodgingRoomModel(
      accommodationId: json['accommodationId'] as String,
      name: json['name'] as String,
      itemTags:
          (json['itemTags'] as List<dynamic>).map((e) => e as String).toList(),
      checkInTime: json['checkInTime'] as String,
      checkOutTime: json['checkOutTime'] as String,
      availableFrom: DateTime.parse(json['availableFrom'] as String),
      availableTo: DateTime.parse(json['availableTo'] as String),
      maxOccupancy: json['maxOccupancy'] as int,
      imageUrls:
          (json['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
      originalPrice: json['originalPrice'] as int,
      finalPrice: json['finalPrice'] as int,
      dailyStock: json['dailyStock'] as int,
      isActive: json['isActive'] as bool,
      id: json['id'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accommodationId': accommodationId,
      'name': name,
      'itemTags': itemTags,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'availableFrom': availableFrom.toIso8601String(),
      'availableTo': availableTo.toIso8601String(),
      'maxOccupancy': maxOccupancy,
      'imageUrls': imageUrls,
      'originalPrice': originalPrice,
      'finalPrice': finalPrice,
      'dailyStock': dailyStock,
      'isActive': isActive,
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class LodgingRoomPageResponse {
  final List<LodgingRoomModel> items;
  final int total;
  final int page;
  final int limit;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LodgingRoomPageResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  factory LodgingRoomPageResponse.fromJson(Map<String, dynamic> json) {
    return LodgingRoomPageResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => LodgingRoomModel.fromJson(e))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      limit: json['limit'] as int,
      id: json['id'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }
}
