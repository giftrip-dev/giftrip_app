class UserModel {
  final String id;
  final String certificateStatus;
  final bool? isTermsOfServiceConsent;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String email;
  final String? nickname;
  final String? phoneNumber;
  final String? name;
  final String? birthDate;
  final bool isFirstLogin;

  UserModel({
    required this.id,
    required this.certificateStatus,
    this.isTermsOfServiceConsent,
    required this.createdAt,
    required this.updatedAt,
    required this.email,
    this.nickname,
    this.phoneNumber,
    this.name,
    this.birthDate,
    required this.isFirstLogin,
  });

  /// JSON 데이터를 Dart 객체로 변환
  factory UserModel.fromJson(Map<String, dynamic> json,
      {bool? isFirstLogin, String? certificateStatus}) {
    return UserModel(
      id: json['id'],
      certificateStatus:
          certificateStatus ?? json['certificateStatus'] ?? 'NOT_REQUESTED',
      isTermsOfServiceConsent: json['isTermsOfServiceConsent'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      email: json['email'],
      nickname: json['nickname'],
      phoneNumber: json['phoneNumber'],
      name: json['name'],
      birthDate: json['birthDate'],
      isFirstLogin: isFirstLogin ?? false,
    );
  }

  /// Dart 객체를 JSON 데이터로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'certificateStatus': certificateStatus,
      'isTermsOfServiceConsent': isTermsOfServiceConsent,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'email': email,
      'nickname': nickname,
      'phoneNumber': phoneNumber,
      'name': name,
      'birthDate': birthDate,
      'isFirstLogin': isFirstLogin,
    };
  }
}
