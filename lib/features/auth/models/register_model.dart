class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String phoneNumber;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
    };
  }
}

class RegisterResponse {
  final bool isSuccess;
  final String? errorMessage;
  final String? userId;
  final String? accessToken;
  final String? refreshToken;

  RegisterResponse({
    required this.isSuccess,
    this.errorMessage,
    this.userId,
    this.accessToken,
    this.refreshToken,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      isSuccess: json['isSuccess'] ?? false,
      errorMessage: json['errorMessage'],
      userId: json['userId'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
