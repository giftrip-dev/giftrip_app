import 'package:flutter/material.dart';
import 'package:giftrip/features/user/models/dto/user_dto.dart';
import 'package:giftrip/features/user/repositories/user_repo.dart';
import 'package:giftrip/core/storage/auth_storage.dart';
import 'package:giftrip/features/auth/models/user_model.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _repository = UserRepository();
  final AuthStorage _authStorage = AuthStorage();
  bool _isLoading = false; // 로딩 상태 추가

  bool get isLoading => _isLoading; // 로딩 상태 getter

  Future<bool> updateUser(UserUpdateRequestDto dto) async {
    try {
      await _repository.updateUser(dto);
      return true; // 업데이트 성공
    } catch (e) {
      return false; // 업데이트 실패
    }
  }

  // 닉네임 업데이트
  Future<String?> updateUserNickname(String nickname) async {
    try {
      // 닉네임 중복 체크
      bool isAvailable = await _repository.checkNickname(nickname);
      print('isAvailable: $isAvailable');
      if (!isAvailable) {
        print('중복된 닉네임입니다~~~~~~~~~~~.');
        // 중복된 경우
        return '중복된 닉네임입니다.'; // 중복된 경우 에러 메시지 반환
      }
      await _repository
          .updateUserNickname(UserUpdateRequestDto(nickname: nickname));
      return null; // 업데이트 성공
    } catch (e) {
      print('닉네임 업데이트에 실패했습니다~~~~~~~~~~~.');
      return '닉네임 업데이트에 실패했습니다.'; // 업데이트 실패 메시지 반환
    }
  }

  Future<UserModel?> getUserInfo() async {
    _isLoading = true; // 로딩 시작
    notifyListeners(); // 상태 변경 알림
    try {
      final userInfo = await _repository.getUserInfo();
      if (userInfo != null) {
        print('유저 정보(이름): ${userInfo.name}');
        await _authStorage.setUserInfo(userInfo); // 유저 정보를 AuthStorage에 저장
        return userInfo; // UserResponseDto를 UserModel로 변환하여 반환
      }
      return null; // 조회 실패
    } catch (e) {
      return null; // 조회 실패
    } finally {
      _isLoading = false; // 로딩 종료
      notifyListeners(); // 상태 변경 알림
    }
  }
}
