class InfluencerInfoRequest {
  final bool isInfluencer;
  final String? domain;
  final String? customDomain;
  final String? accountName;

  InfluencerInfoRequest({
    required this.isInfluencer,
    this.domain,
    this.customDomain,
    this.accountName,
  });

  Map<String, dynamic> toJson() {
    return {
      'isInfluencer': isInfluencer,
      'domain': domain,
      'customDomain': customDomain,
      'accountName': accountName,
    };
  }
}

class InfluencerInfoResponse {
  final bool isSuccess;
  final String? errorMessage;

  InfluencerInfoResponse({
    required this.isSuccess,
    this.errorMessage,
  });

  factory InfluencerInfoResponse.fromJson(Map<String, dynamic> json) {
    return InfluencerInfoResponse(
      isSuccess: json['isSuccess'] ?? false,
      errorMessage: json['errorMessage'],
    );
  }
}
