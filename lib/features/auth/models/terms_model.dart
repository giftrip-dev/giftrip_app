class TermsAgreementRequest {
  final bool isTermsOfServiceConsent;
  final bool isPersonalInfoConsent;
  final bool isAdvConsent;

  TermsAgreementRequest({
    required this.isTermsOfServiceConsent,
    required this.isPersonalInfoConsent,
    required this.isAdvConsent,
  });

  Map<String, dynamic> toJson() {
    return {
      'isTermsOfServiceConsent': isTermsOfServiceConsent,
      'isPersonalInfoConsent': isPersonalInfoConsent,
      'isAdvConsent': isAdvConsent,
    };
  }
}

class TermsAgreementResponse {
  final bool isSuccess;
  final String? errorMessage;
  final String? userId;

  TermsAgreementResponse({
    required this.isSuccess,
    this.errorMessage,
    this.userId,
  });

  factory TermsAgreementResponse.fromJson(Map<String, dynamic> json) {
    return TermsAgreementResponse(
      isSuccess: json['isSuccess'] ?? false,
      errorMessage: json['errorMessage'],
      userId: json['userId'],
    );
  }
}
