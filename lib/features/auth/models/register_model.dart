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
  final Tokens tokens;
  final String? name;
  final bool isInfluencerChecked;
  RegisterResponse({
    required this.tokens,
    this.name,
    this.isInfluencerChecked = false,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      tokens: Tokens(
        accessToken: json['tokens']['accessToken'],
        refreshToken: json['tokens']['refreshToken'],
      ),
      name: json['name'],
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
  final bool? isMarketingAgreed;
  final bool? isTermsAgreed;
  final bool? isPrivacyAgreed;
  final bool isInfluencer;
  final InfluencerInfo? influencerInfo;

  CompleteSignUpRequest({
    this.isMarketingAgreed = false,
    this.isTermsAgreed = false,
    this.isPrivacyAgreed = false,
    required this.isInfluencer,
    this.influencerInfo,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'isInfluencer': isInfluencer,
    };

    // 약관 동의 정보들이 null이 아닌 경우에만 포함
    if (isMarketingAgreed != null) {
      json['isMarketingAgreed'] = isMarketingAgreed;
    }
    if (isTermsAgreed != null) {
      json['isTermsAgreed'] = isTermsAgreed;
    }
    if (isPrivacyAgreed != null) {
      json['isPrivacyAgreed'] = isPrivacyAgreed;
    }

    // 인플루언서 정보가 있을 때만 포함
    if (influencerInfo != null) {
      json['influencerInfo'] = influencerInfo!.toJson();
    }

    return json;
  }
}
