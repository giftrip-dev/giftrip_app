import 'dart:io';
import 'package:dio/dio.dart';

final Dio _dio = Dio();

/// S3 presigned Url 요청
Future<String?> getPresignedUrl(String fileName) async {
  try {
    final response = await _dio.get(
      "https://your-api.com/s3/presigned-url",
      queryParameters: {"file_name": fileName},
    );

    if (response.statusCode == 200) {
      return response.data["presignedUrl"];
    }
  } catch (e) {
    print("Failed to get presigned URL: $e");
  }
  return null;
}

/// S3 업로드 요청
Future<String?> uploadToS3(String presignedUrl, File imageFile) async {
  try {
    await _dio.put(
      presignedUrl,
      data: imageFile.openRead(),
      options: Options(
        headers: {"Content-Type": "image/jpeg"},
      ),
    );
    return presignedUrl.split("?").first;
  } catch (e) {
    print("Failed to upload to S3: $e");
    return null;
  }
}
