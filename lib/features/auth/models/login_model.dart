class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class LoginResponse {
  final bool isSuccess;
  final String? errorMessage;
  final String? accessToken;
  final String? refreshToken;
  final String? name;
  final bool isInfluencerChecked;

  LoginResponse({
    required this.isSuccess,
    this.errorMessage,
    this.accessToken,
    this.refreshToken,
    this.name,
    required this.isInfluencerChecked,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      isSuccess: json['isSuccess'] ?? false,
      errorMessage: json['errorMessage'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      name: json['name'],
      isInfluencerChecked: json['isInfluencerChecked'],
    );
  }
}
