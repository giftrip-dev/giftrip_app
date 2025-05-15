import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/core/services/storage_service.dart';
import 'package:giftrip/core/utils/logger.dart';

// 피드백 DTO
class FeedbackDto {
  final String feedbackType;
  final String? detail;

  FeedbackDto({required this.feedbackType, this.detail});

  Map<String, dynamic> toJson() {
    return {
      'feedbackType': feedbackType,
      if (detail != null) 'detail': detail,
    };
  }
}

class LeaveRepo {
  final Dio _dio = DioClient().to();
  final GlobalStorage _storage = GlobalStorage();

  /// 회원 탈퇴 요청
  Future<bool> deleteUser() async {
    try {
      final response = await _dio.delete('/api/users/withdrawal');

      if (response.statusCode == 200) {
        await _storage.deleteUserInfo();
        await _storage.deleteLoginToken();
        await _storage.removeAutoLogin();
        return true;
      } else {
        logger.e('회원탈퇴 실패: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      logger.e('회원탈퇴 API 요청 실패: $e');
      return false;
    }
  }

  /// 탈퇴 피드백 요청
  Future<bool> postFeedback(List<FeedbackDto> feedback) async {
    try {
      await _dio.post(
        '/api/users/withdrawal/feedback',
        data: {'feedbacks': feedback.map((f) => f.toJson()).toList()},
      );

      return true;
    } catch (e) {
      throw Exception('탈퇴 피드백 API 요청 실패: $e');
    }
  }
}
