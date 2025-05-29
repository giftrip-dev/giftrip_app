import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/core/services/storage_service.dart';
import 'package:giftrip/core/storage/auth_storage.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/features/auth/models/auth_result_model.dart';
import 'package:giftrip/features/auth/models/user_model.dart';
import 'package:giftrip/features/notification/view_models/notification_view_model.dart';
import 'package:giftrip/features/notification/models/notification_model.dart';
import 'package:giftrip/features/user/models/dto/user_dto.dart';
import 'package:giftrip/features/user/view_models/user_view_model.dart';

class AuthRepository {
  final Dio _dio = DioClient().to();
  final Map<String, dynamic> resultMap = <String, dynamic>{};
  final AuthStorage _authStorage = AuthStorage();
  final GlobalStorage _globalStorage = GlobalStorage();

  // 리프레쉬 토큰으로 액세스 토큰 재발급
  Future<void> refreshAccessToken() async {
    try {
      String? refreshToken = await _authStorage.getRefreshToken();
      if (refreshToken == null) {
        throw Exception("리프레시 토큰이 없음");
      }

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 201) {
        final tokenInfo = response.data;
        await _authStorage.setToken(
            tokenInfo['accessToken'], tokenInfo['refreshToken']);
        logger.d('새로운 액세스 토큰 저장 완료: ${tokenInfo['accessToken']}');
      } else {
        throw Exception("토큰 갱신 실패: ${response.statusCode}");
      }
    } catch (e) {
      logger.e("토큰 갱신 중 오류 발생: $e");
      rethrow;
    }
  }

  // 소셜 로그인 요청
  Future<LoginRes> postLoginWithSocial(
    String accessToken, {
    String? provider,
  }) async {
    final response = await _dio.post(
      '/auth/social-login',
      data: {
        'provider': provider,
        'accessToken': accessToken,
      },
    );

    if (response.statusCode == 201) {
      final refreshToken = response.data['tokens']['refreshToken'];
      final accessToken = response.data['tokens']['accessToken'];

      final user = UserModel.fromJson(
        response.data,
        name: response.data['name'],
        isInfluencerChecked: response.data['isInfluencerChecked'],
      );

      final fcmToken = await _globalStorage.getFcmToken();
      final deviceId = await _globalStorage.getDeviceId();
      final deviceModel = await _globalStorage.getDeviceModel();
      final notificationViewModel = NotificationViewModel();
      // 토큰, 유저 정보 글로벌 스토리지 저장
      await _authStorage.setToken(accessToken, refreshToken);
      await _authStorage.setUserInfo(user);
      await _authStorage.setAutoLogin(); // 자동 로그인 활성화
      await notificationViewModel.registerFCMToken(
          fcmData: FCMTokenModel(
        token: fcmToken ?? '',
        deviceId: deviceId ?? '',
        deviceModel: deviceModel ?? '',
      ));

      UserViewModel().updateUser(UserUpdateRequestDto(
        name: user.name,
        isInfluencerChecked: user.isInfluencerChecked,
      ));

      return LoginRes(
        tokens: TokenModel(
          refreshToken: refreshToken,
          accessToken: accessToken,
        ),
        name: user.name,
        isInfluencerChecked: user.isInfluencerChecked,
      );
    } else {
      throw Exception("로그인 실패: ${response.statusCode}");
    }
  }

  /// 로그아웃 요청
  Future<bool> logout() async {
    try {
      final response = await _dio.post('/auth/logout');

      if (response.statusCode == 201) {
        await _authStorage.deleteUserInfo();
        await _authStorage.deleteLoginToken();
        await _authStorage.removeAutoLogin();
        return true;
      } else {
        throw Exception('로그아웃 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('로그아웃 API 요청 실패: $e');
    }
  }
}
