import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';
import 'package:giftrip/features/auth/models/influencer_model.dart';
import 'dart:developer' as developer;

class InfluencerRepository {
  final Dio _dio = DioClient().to();

  Future<InfluencerInfoResponse> updateInfluencerInfo(
      InfluencerInfoRequest request) async {
    try {
      developer.log(
        '인플루언서 정보 업데이트 요청',
        name: 'InfluencerRepository',
        error: request.toJson(),
      );

      // TODO: 실제 API 구현 시 아래 주석 해제
      // final response = await _dio.post(
      //   '/api/auth/influencer-info',
      //   data: request.toJson(),
      // );
      //
      // if (response.statusCode == 201) {
      //   developer.log(
      //     '인플루언서 정보 업데이트 성공',
      //     name: 'InfluencerRepository',
      //     error: response.data,
      //   );
      //   return InfluencerInfoResponse.fromJson(response.data);
      // } else {
      //   developer.log(
      //     '인플루언서 정보 업데이트 실패',
      //     name: 'InfluencerRepository',
      //     error: response.data,
      //   );
      //   return InfluencerInfoResponse(
      //     isSuccess: false,
      //     errorMessage: '인플루언서 정보 업데이트에 실패했습니다.',
      //   );
      // }

      // 임시: 성공으로 처리
      developer.log(
        '인플루언서 정보 업데이트 임시 성공',
        name: 'InfluencerRepository',
      );
      return InfluencerInfoResponse(
        isSuccess: true,
      );
    } catch (e, stackTrace) {
      developer.log(
        '인플루언서 정보 업데이트 중 오류 발생',
        name: 'InfluencerRepository',
        error: e,
        stackTrace: stackTrace,
      );
      return InfluencerInfoResponse(
        isSuccess: false,
        errorMessage: '인플루언서 정보 업데이트 중 오류가 발생했습니다.',
      );
    }
  }
}
