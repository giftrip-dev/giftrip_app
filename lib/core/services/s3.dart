import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:myong/core/services/api_service.dart';

/// 파일 도메인
enum FileDomain {
  post,
  user,
  certificate,
  reservation,
}

/// enum에서 string 변환
extension FileDomainExtension on FileDomain {
  String get value {
    switch (this) {
      case FileDomain.post:
        return 'POST';
      case FileDomain.user:
        return 'USER';
      case FileDomain.certificate:
        return 'CERTIFICATE';
      case FileDomain.reservation:
        return 'RESERVATION';
    }
  }
}

class S3FileUploaderService {
  final Dio _dio = DioClient().to();

  /// 1) 서버로부터 프리사인드 URL 발급 받기
  Future<List<PresignedUrlResponse>> getPresignedUrls({
    required List<String> fileNames,
    required String domain, //  "POST", "USER", "CERTIFICATE", "RESERVATION"
  }) async {
    final requestData = {
      'fileName': fileNames,
      'domain': domain,
    };

    final response = await _dio.post(
      '/api/file/upload/presigned-url',
      data: requestData,
    );

    final List<dynamic> urls = response.data['urls'];

    // 응답을 PresignedUrlResponse 형태로 파싱
    return urls
        .map((json) =>
            PresignedUrlResponse.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// 2) 발급받은 프리사인드 URL로 실제 S3에 파일 PUT 업로드
  Future<void> uploadFileToS3({
    required String presignedUrl,
    required String filePath, // 디바이스 상의 파일 경로
  }) async {
    final Dio dioForUpload = Dio();

    // 1) 파일 바이트로 읽기
    final fileBytes = await _getFileBytes(filePath);

    // 2) PUT 업로드
    final response = await dioForUpload.put(
      presignedUrl,
      data: fileBytes,
      options: Options(
        headers: {
          // 파일 형식에 맞게 Content-Type 설정
          Headers.contentTypeHeader: _getContentType(filePath),
        },
      ),
    );

    // 실패일 경우
    if (response.statusCode != 200) {
      throw Exception('파일 업로드 실패 (status: ${response.statusCode})');
    }
  }

  /// 파일을 바이트로 읽어오는 헬퍼 메서드
  Future<Uint8List> _getFileBytes(String filePath) async {
    final file = File(filePath);
    return await file.readAsBytes();
  }

  /// 파일 확장자를 보고 Content-Type 추론
  String _getContentType(String path) {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'gif':
        return 'image/gif';
      default:
        return 'application/octet-stream';
    }
  }
}

/// 프리사인드 요청 응답 DTO
class PresignedUrlResponse {
  final String presignedUrl;
  final String fileUrl;

  PresignedUrlResponse({
    required this.presignedUrl,
    required this.fileUrl,
  });

  factory PresignedUrlResponse.fromJson(Map<String, dynamic> json) {
    return PresignedUrlResponse(
      presignedUrl: json['presignedUrl'] as String,
      fileUrl: json['fileUrl'] as String,
    );
  }
}
