class UserUpdateRequestDto {
  final String? nickname;
  final bool? isTermsOfServiceConsent;
  final bool? isPersonalInfoConsent;
  final bool? isAdvConsent;

  UserUpdateRequestDto({
    this.nickname,
    this.isTermsOfServiceConsent,
    this.isPersonalInfoConsent,
    this.isAdvConsent,
  });

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'isTermsOfServiceConsent': isTermsOfServiceConsent,
      'isPersonalInfoConsent': isPersonalInfoConsent,
      'isAdvConsent': isAdvConsent,
    };
  }
}

class UserResponseDto {
  final String id;
  final String certificateStatus;
  final bool isTermsOfServiceConsent;
  final String certifiedAt;
  final String createdAt;
  final String updatedAt;
  final String email;
  final String nickname;
  final String phoneNumber;
  final String name;
  final String birthDate;

  UserResponseDto({
    required this.id,
    required this.certificateStatus,
    required this.isTermsOfServiceConsent,
    required this.certifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.email,
    required this.nickname,
    required this.phoneNumber,
    required this.name,
    required this.birthDate,
  });

  factory UserResponseDto.fromJson(Map<String, dynamic> json) {
    return UserResponseDto(
      id: json['id'],
      certificateStatus: json['certificateStatus'],
      isTermsOfServiceConsent: json['isTermsOfServiceConsent'],
      certifiedAt: json['certifiedAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      email: json['email'],
      nickname: json['nickname'],
      phoneNumber: json['phoneNumber'],
      name: json['name'],
      birthDate: json['birthDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'certificateStatus': certificateStatus,
      'isTermsOfServiceConsent': isTermsOfServiceConsent,
      'certifiedAt': certifiedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'email': email,
      'nickname': nickname,
      'phoneNumber': phoneNumber,
      'name': name,
      'birthDate': birthDate,
    };
  }
}
