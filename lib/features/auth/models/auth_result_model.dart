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

class TokenModel {
  final String refreshToken;
  final String accessToken;

  TokenModel({
    required this.refreshToken,
    required this.accessToken,
  });
}

class LoginRes {
  final TokenModel tokens;
  final String? name;
  final bool isInfluencerChecked;

  LoginRes({
    required this.tokens,
    required this.name,
    required this.isInfluencerChecked,
  });
}
