class RegisterRequest {
  final String name;
  final String phoneNumber;
  final bool isMarketingAgreed;
  final bool isTermsAgreed;
  final bool isPrivacyAgreed;
  final String email;
  final String password;
  final String passwordConfirm;

  RegisterRequest({
    required this.name,
    required this.phoneNumber,
    required this.isMarketingAgreed,
    required this.isTermsAgreed,
    required this.isPrivacyAgreed,
    required this.email,
    required this.password,
    required this.passwordConfirm,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'isMarketingAgreed': isMarketingAgreed,
      'isTermsAgreed': isTermsAgreed,
      'isPrivacyAgreed': isPrivacyAgreed,
      'email': email,
      'password': password,
      'passwordConfirm': passwordConfirm,
    };
  }
}

class Tokens {
  final String accessToken;
  final String refreshToken;

  Tokens({
    required this.accessToken,
    required this.refreshToken,
  });
}

class RegisterResponse {
  final Tokens? tokens;
  final bool isInfluencerChecked;
  RegisterResponse({
    this.tokens,
    this.isInfluencerChecked = false,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      tokens: json['tokens'] != null
          ? Tokens(
              accessToken: json['tokens']['accessToken'],
              refreshToken: json['tokens']['refreshToken'],
            )
          : null,
      isInfluencerChecked: json['isInfluencerChecked'],
    );
  }
}

class InfluencerInfo {
  final String platform;
  final String platformId;

  InfluencerInfo({
    required this.platform,
    required this.platformId,
  });

  Map<String, dynamic> toJson() => {
        'platform': platform,
        'platformId': platformId,
      };
}

class CompleteSignUpRequest {
  final bool isMarketingAgreed;
  final bool isTermsAgreed;
  final bool isPrivacyAgreed;
  final bool isInfluencer;
  final InfluencerInfo influencerInfo;

  CompleteSignUpRequest({
    required this.isMarketingAgreed,
    required this.isTermsAgreed,
    required this.isPrivacyAgreed,
    required this.isInfluencer,
    required this.influencerInfo,
  });

  Map<String, dynamic> toJson() => {
        'isMarketingAgreed': isMarketingAgreed,
        'isTermsAgreed': isTermsAgreed,
        'isPrivacyAgreed': isPrivacyAgreed,
        'isInfluencer': isInfluencer,
        'influencerInfo': influencerInfo.toJson(),
      };
}

class CompleteSignUpResponse {
  final bool isInfluencerChecked;

  CompleteSignUpResponse({required this.isInfluencerChecked});

  factory CompleteSignUpResponse.fromJson(Map<String, dynamic> json) {
    return CompleteSignUpResponse(
      isInfluencerChecked: json['isInfluencerChecked'] ?? false,
    );
  }
}
