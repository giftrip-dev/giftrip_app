import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myong/core/utils/logger.dart';
import 'package:myong/core/services/s3.dart';
import 'package:myong/features/user/models/dto/certificates_dto.dart';
import 'package:myong/features/user/repositories/certificate_repo.dart';
import 'package:myong/core/enum/community_enum.dart';
import 'package:myong/features/user/models/certificate_model.dart';

class CertificateViewModel extends ChangeNotifier {
  final CertificateRepository _repository = CertificateRepository();
  final S3FileUploaderService _uploader = S3FileUploaderService();
  File? _selectedImage;
  bool _isUploading = false;
  bool _isLoading = false; // 로딩 상태 추가

  File? get selectedImage => _selectedImage;
  bool get isUploading => _isUploading;

  /// ✅ 이미지 선택 핸들러 (파일 크기 검사 포함)
  Future<void> handlePickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      File imageFile = File(image.path);
      int fileSize = await imageFile.length(); // 파일 크기 가져오기 (bytes)

      if (fileSize > 1024 * 1024) {
        // ✅ 1MB 초과 검사
        logger.d("이미지 크기가 너무 큼: ${fileSize / 1024} KB");
        return;
      }

      setSelectedImage(imageFile);
    }
  }

  /// ✅ 이미지 설정 핸들러 (setter 역할)
  void setSelectedImage(File? file) {
    _selectedImage = file;
    notifyListeners();
  }

  /// ✅ S3 업로드 및 유저 정보 업데이트 핸들러
  Future<bool> handleUploadCertificate({
    required BeautyCategory category,
  }) async {
    if (_selectedImage == null) {
      logger.d("No image selected");
      return false;
    }

    _isUploading = true;
    notifyListeners();

    String fileName =
        "certificate_${DateTime.now().millisecondsSinceEpoch}.jpg";

    // 1. Presigned URL 받기
    final presignedList = await _uploader.getPresignedUrls(
      fileNames: [fileName],
      domain: FileDomain.certificate.value,
    );
    if (presignedList.isEmpty) {
      logger.d("Failed to get presigned URL");
      _isUploading = false;
      notifyListeners();
      return false;
    }

    // 2. S3에 이미지 업로드
    await _uploader.uploadFileToS3(
      presignedUrl: presignedList[0].presignedUrl,
      filePath: _selectedImage!.path,
    );

    // 3. 업로드 된 URL 서버에 전송
    final certificateUpdateRequest = CertificatesUpdateRequestDto(
      category: BeautyCategory.toUpperString(category),
      type: "EMPLOYMENT_INFO",
      fileUrl: presignedList[0].fileUrl,
    );

    await _repository.postCertificate(certificateUpdateRequest);

    _isUploading = false;
    notifyListeners();
    return true;
  }

  /// ✅ 이미지 없이 자격증 업로드 핸들러
  Future<void> handleUploadCertificateNoImage({
    required BeautyCategory category,
    required String name,
    required String birthDate,
    required String designerName,
    required String storeName,
    String? instagramId,
  }) async {
    final certificateUpdateRequest = CertificatesUpdateRequestDto(
      category: BeautyCategory.toUpperString(category),
      type: "EMPLOYMENT_INFO",
      name: name,
      birthDate: birthDate,
      designerName: designerName,
      storeName: storeName,
      instagramId: instagramId,
    );

    await _repository.postCertificate(certificateUpdateRequest);
  }

  /// ✅ 자격증 조회
  Future<List<CertificateModel>?> getCertificate() async {
    _isLoading = true;
    notifyListeners();
    try {
      final certificates = await _repository.getCertificate();
      if (certificates != null) {
        logger.i("Certificates retrieved successfully: ${certificates.length}");
        return certificates;
      } else {
        logger.e("No certificates found");
        return null;
      }
    } catch (e) {
      logger.e("Error retrieving certificates: $e");
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
