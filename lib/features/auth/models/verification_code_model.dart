class VerificationCode {
  final String phone;
  final String code;

  VerificationCode({
    required this.phone,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'code': code,
    };
  }
}

class Error {
  final String? code;
  final String? message;
  final int? remainingAttempts;
  final int? expiresIn;

  Error({
    this.code,
    this.message,
    this.remainingAttempts,
    this.expiresIn,
  });

  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(
      code: json['code'],
      message: json['message'],
      remainingAttempts: json['remainingAttempts'],
      expiresIn: json['expiresIn'],
    );
  }
}

class VerificationResult {
  final bool? isSended;
  final int? dailyRemaining;
  final bool? success;
  final bool? isVerified;
  final Error? error;
  final String phone;

  VerificationResult({
    this.isSended,
    this.dailyRemaining,
    this.success,
    this.isVerified,
    this.error,
    required this.phone,
  });

  factory VerificationResult.fromJson(Map<String, dynamic> json) {
    return VerificationResult(
      isSended: json['isSended'],
      dailyRemaining: json['dailyRemaining'],
      success: json['success'],
      isVerified: json['isVerified'],
      error: json['error'] != null ? Error.fromJson(json['error']) : null,
      phone: json['phone'],
    );
  }
}
