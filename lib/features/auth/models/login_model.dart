class LoginRequest {
  final String id;
  final String password;

  LoginRequest({
    required this.id,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
    };
  }
}

class LoginResponse {
  final bool isSuccess;
  final String? errorMessage;
  final String? accessToken;
  final String? refreshToken;
  final String? userId;

  LoginResponse({
    required this.isSuccess,
    this.errorMessage,
    this.accessToken,
    this.refreshToken,
    this.userId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      isSuccess: json['isSuccess'] ?? false,
      errorMessage: json['errorMessage'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userId: json['userId'],
    );
  }
}
