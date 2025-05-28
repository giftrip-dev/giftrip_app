import 'package:dio/dio.dart';
import 'package:giftrip/core/services/api_service.dart';

class PaymentRepo {
  final Dio _dio = DioClient().to();

  /// 결제 취소
  Future<void> cancelPayment(String transactionId) async {
    // 실제 API 호출 코드 (현재 주석 처리)
    // try {
    //   final response = await _dio.post(
    //     '/api/payment/cancel',
    //     data: {
    //       'transactionId': transactionId,
    //     },
    //   );
    //
    //   if (response.statusCode != 200) {
    //     throw Exception('결제 취소 실패: ${response.statusMessage}');
    //   }
    // } catch (e) {
    //   throw Exception('결제 취소 요청 실패: $e');
    // }

    // 목업 데이터 처리 - 취소 시뮬레이션
    await Future.delayed(const Duration(milliseconds: 1000));

    // 성공적으로 취소된 것으로 시뮬레이션
    // 실제 환경에서는 서버 응답을 확인하여 성공/실패 처리
  }

  /// 환불 상태 조회
  Future<Map<String, dynamic>> getRefundStatus(String transactionId) async {
    // 실제 API 호출 코드 (현재 주석 처리)
    // try {
    //   final response = await _dio.get('/api/payment/refund/$transactionId');
    //   return response.data;
    // } catch (e) {
    //   throw Exception('환불 상태 조회 실패: $e');
    // }

    // 목업 데이터
    await Future.delayed(const Duration(milliseconds: 500));

    return {
      'transactionId': transactionId,
      'status': 'completed', // completed, pending, failed
      'refundAmount': 50000,
      'refundedAt': DateTime.now().toIso8601String(),
      'reason': '고객 요청에 의한 취소',
    };
  }
}
