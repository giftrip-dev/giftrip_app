import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:giftrip/features/auth/models/user_model.dart';

class AuthStorage {
  final _storage = FlutterSecureStorage();

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> _read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> _delete(String key) async {
    await _storage.delete(key: key);
  }

  // 토큰
  Future<void> setToken(String accessToken, String refreshToken) async {
    await write("accessToken", accessToken);
    await write("refreshToken", refreshToken);
  }

  Future<String?> getAccessToken() async => _read("accessToken");
  Future<String?> getRefreshToken() async => _read("refreshToken");
  Future<void> deleteLoginToken() async {
    await _delete("accessToken");
    await _delete("refreshToken");
  }

  // 유저
  Future<void> setUserInfo(UserModel user) async {
    await write("userInfo", jsonEncode(user.toJson()));
  }

  Future<UserModel?> getUserInfo() async {
    final jsonString = await _read("userInfo");
    return jsonString != null
        ? UserModel.fromJson(jsonDecode(jsonString))
        : null;
  }

  Future<void> deleteUserInfo() async => _delete("userInfo");

  // 자동 로그인
  Future<void> setAutoLogin() async => write("autoLogin", "T");
  Future<bool> getAutoLogin() async => (await _read("autoLogin")) == "T";
  Future<void> removeAutoLogin() async => write("autoLogin", "N");
}
