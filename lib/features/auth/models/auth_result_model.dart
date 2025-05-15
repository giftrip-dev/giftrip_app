import 'package:giftrip/features/auth/models/user_model.dart';

class AuthRes {
  final bool isSuccess;
  final UserModel? user;
  final String? errorMessage;

  AuthRes({
    required this.isSuccess,
    this.user,
    this.errorMessage,
  });
}

class LoginRes {
  final String statusCode;
  final String refreshToken;
  final String accessToken;
  final UserModel user;

  LoginRes({
    required this.statusCode,
    required this.refreshToken,
    required this.accessToken,
    required this.user,
  });
}
