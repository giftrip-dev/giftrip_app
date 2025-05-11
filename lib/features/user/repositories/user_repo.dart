import 'package:dio/dio.dart';
import 'package:myong/core/utils/logger.dart';
import 'package:myong/features/user/models/dto/user_dto.dart';
import 'package:myong/core/services/api_service.dart';
import 'package:myong/features/auth/models/user_model.dart';

class UserRepository {
  final Dio _dio = DioClient().to();

  /// 유저 정보 업데이트 요청
  Future<UserResponseDto?> updateUser(UserUpdateRequestDto dto) async {
    try {
      logger.i("유저 정보 업데이트 요청: $dto");
      Response response = await _dio.patch(
        "/api/users/me",
        data: {
          'isTermsOfServiceConsent': dto.isTermsOfServiceConsent,
          'isPersonalInfoConsent': dto.isPersonalInfoConsent,
          'isAdvConsent': dto.isAdvConsent,
        },
      );

      if (response.statusCode == 200) {
        logger.i("유저 정보 업데이트 성공: ${response.data}");
        return UserResponseDto.fromJson(response.data);
      } else {
        logger.e("유저 정보 업데이트 실패: ${response.statusCode}");
      }
    } catch (e) {
      logger.e("유저 정보 업데이트 요청 실패: $e");
    }
    return null;
  }

  /// 유저 닉네임 업데이트 요청
  Future<UserResponseDto?> updateUserNickname(UserUpdateRequestDto dto) async {
    try {
      logger.i("유저 닉네임 업데이트 요청: $dto");
      Response response = await _dio.patch(
        "/api/users/me",
        data: {
          'nickname': dto.nickname,
        },
      );

      if (response.statusCode == 200) {
        logger.i("유저 닉네임 업데이트 성공: ${response.data}");
        return UserResponseDto.fromJson(response.data);
      } else {
        logger.e("유저 닉네임 업데이트 실패: ${response.statusCode}");
      }
    } catch (e) {
      logger.e("유저 닉네임 업데이트 요청 실패: $e");
    }
    return null;
  }

  /// 유저 닉네임 중복 체크
  Future<bool> checkNickname(String nickname) async {
    try {
      Response response =
          await _dio.get("/api/users/check-nickname?nickname=$nickname");
      if (response.data.toString() == "true") {
        logger.i("중복 유저 입니다: ${response.data}");
        return false; // 중복되는 닉네임
      } else {
        logger.i("중복 유저 아닙니다: ${response.data}");
        return true; // 중복되지 않는 닉네임
      }
    } catch (e) {
      logger.e("유저 닉네임 중복 체크 요청 실패: $e");
    }
    return false; // 중복 체크 실패
  }

  /// 유저 정보 조회
  Future<UserModel?> getUserInfo() async {
    try {
      Response response = await _dio.get("/api/users/me");
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        logger.e("유저 정보 조회 실패: ${response.statusCode}");
      }
    } catch (e) {
      logger.e("유저 정보 조회 요청 실패: $e");
    }
    return null;
  }

  /// 사용자 차단 요청
  Future<void> postBlockUser(String userId) async {
    try {
      Response response = await _dio.post("/api/users/blacklist", data: {
        "userId": userId,
      });
      if (response.statusCode == 200) {
        logger.i("사용자 차단 요청 성공: ${response.data}");
      } else {
        logger.e("사용자 차단 요청 실패: ${response.statusCode}");
      }
    } catch (e) {
      logger.e("사용자 차단 요청 실패: $e");
    }
  }
}
