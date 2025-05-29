class UserModel {
  final bool? isTermsOfServiceConsent;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? email;
  final String? phoneNumber;
  final String? name;
  final bool isInfluencerChecked; // 인플루언서 인증 여부

  UserModel({
    this.isTermsOfServiceConsent,
    this.createdAt,
    this.updatedAt,
    this.email,
    this.phoneNumber,
    this.name,
    required this.isInfluencerChecked,
  });

  /// JSON 데이터를 Dart 객체로 변환
  factory UserModel.fromJson(Map<String, dynamic> json,
      {bool? isInfluencerChecked, String? name}) {
    return UserModel(
      isTermsOfServiceConsent: json['isTermsOfServiceConsent'] ?? false,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      name: json['name'],
      isInfluencerChecked: isInfluencerChecked ?? false,
    );
  }

  /// Dart 객체를 JSON 데이터로 변환
  Map<String, dynamic> toJson() {
    return {
      'isTermsOfServiceConsent': isTermsOfServiceConsent,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'email': email,
      'phoneNumber': phoneNumber,
      'name': name,
      'isInfluencerChecked': isInfluencerChecked,
    };
  }
}
