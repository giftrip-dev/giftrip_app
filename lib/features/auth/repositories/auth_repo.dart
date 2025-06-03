import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/core/services/storage_service.dart';
import 'package:giftrip/core/storage/auth_storage.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/features/auth/models/auth_result_model.dart';
import 'package:giftrip/features/auth/models/login_model.dart';
import 'package:giftrip/features/auth/models/user_model.dart';
import 'package:giftrip/features/auth/models/register_model.dart';
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
        '/auth/rotate-tokens',
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

  // 회원가입 요청
  Future<RegisterResponse> postSignUp(RegisterRequest request) async {
    try {
      logger.d('회원가입 요청 데이터: ${request.toJson()}');
      final response = await _dio.post(
        '/auth/sign-up',
        data: request.toJson(),
      );

      final data = response.data;
      logger.d('회원가입 응답 데이터: $data');
      final accessToken = data['tokens']['accessToken'];
      final refreshToken = data['tokens']['refreshToken'];

      // 유저 스토리지 업데이트
      await _authStorage.setUserInfo(UserModel.fromJson(data));

      // 토큰 스토리지 업데이트
      if (accessToken != null && refreshToken != null) {
        await _authStorage.setToken(accessToken, refreshToken);
      } else {
        logger.e(
            '토큰이 null입니다. accessToken: $accessToken, refreshToken: $refreshToken');
      }

      return RegisterResponse.fromJson(data);
    } catch (e) {
      logger.e('회원가입 중 오류: $e');
      if (e is DioException) {
        logger.e('DioException 응답 데이터: ${e.response?.data}');
      }
      rethrow;
    }
  }

  // 로그인 요청
  Future<LoginResponse> postLogin(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      logger.i('로그인 응답 데이터: ${response.data}');

      if (response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;

        // 1) 토큰 저장
        final accessToken = data['tokens']?['accessToken'] as String?;
        final refreshToken = data['tokens']?['refreshToken'] as String?;
        if (accessToken != null && refreshToken != null) {
          await _authStorage.setToken(accessToken, refreshToken);
        } else {
          logger.e(
            '토큰 누락: access=$accessToken, refresh=$refreshToken',
          );
        }

        // 2) 유저 정보 저장 (이름 + 인플루언서 체크 여부)
        final name = data['name'] as String?;
        final isInfluencer = data['isInfluencerChecked'] as bool? ?? false;

        final user = UserModel(
          name: name,
          isInfluencerChecked: isInfluencer,
        );
        await _authStorage.setUserInfo(user);
        await _authStorage.setAutoLogin(); // 자동 로그인 활성화

        // 3) LoginResponse 반환
        return LoginResponse(
          isSuccess: true,
          errorMessage: null,
          accessToken: accessToken,
          refreshToken: refreshToken,
          name: data['name'] as String,
          isInfluencerChecked: isInfluencer,
        );
      }

      return LoginResponse(
        isSuccess: false,
        errorMessage: '로그인에 실패했습니다.',
        isInfluencerChecked: false,
      );
    } catch (e, st) {
      logger.e('로그인 중 오류 발생', error: e, stackTrace: st);
      if (e is DioException &&
          (e.response?.statusCode == 401 || e.response?.statusCode == 404)) {
        return LoginResponse(
          isSuccess: false,
          errorMessage: '아이디 또는 비밀번호가 일치하지 않습니다.',
          isInfluencerChecked: false,
        );
      }
      return LoginResponse(
        isSuccess: false,
        errorMessage: '로그인 중 오류가 발생했습니다.',
        isInfluencerChecked: false,
      );
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
  Future<bool> logout(String refreshToken) async {
    try {
      final response = await _dio.post('/auth/logout', data: {
        'refreshToken': refreshToken,
      });

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

  Future<bool> completeSignUp(CompleteSignUpRequest request) async {
    logger.i('인플루언서 정보 제출 요청: ${request.toJson()}');
    try {
      final accessToken = await _authStorage.getAccessToken();
      logger.i('요청 헤더 토큰: $accessToken');

      final response = await _dio.patch(
        '/auth/complete-sign-up',
        data: request.toJson(),
      );
      if (response.statusCode == 200) {
        // 유저 스토리지 업데이트
        await _authStorage.setUserInfo(UserModel.fromJson(response.data));
        // 유저 뷰모델 업데이트
        UserViewModel().updateUser(UserUpdateRequestDto(
          name: response.data['name'],
          isInfluencerChecked: response.data['isInfluencerChecked'],
        ));
        return true;
      } else {
        throw Exception('회원가입 완료 실패: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
