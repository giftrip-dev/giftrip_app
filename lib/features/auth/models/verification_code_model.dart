class VerificationCode {
  final String phoneNumber;
  final String type;
  final String code;

  VerificationCode({
    required this.phoneNumber,
    required this.type,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'type': type,
      'code': code,
    };
  }
}

class VerificationResult {
  final bool isVerified;
  final String? errorMessage;

  VerificationResult({
    required this.isVerified,
    this.errorMessage,
  });
}
