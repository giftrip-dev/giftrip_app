import 'package:flutter/material.dart';
import 'package:giftrip/core/enum/community_enum.dart';
import 'package:giftrip/core/services/s3.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/features/community/models/dto/post_dto.dart';
import 'package:giftrip/features/community/models/post_model.dart';
import 'package:giftrip/features/community/repositories/community_repo.dart';

class CommunityWriteViewModel extends ChangeNotifier {
  final CommunityRepo _communityRepo = CommunityRepo();
  final S3FileUploaderService _uploader = S3FileUploaderService();

  bool _isSubmitting = false;
  String? _errorMessage;

  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  /// 신규 게시글 작성 (기존)
  Future<bool> submitPost({
    required BeautyCategory beautyCategory,
    required String title,
    required String content,
    required List<String> localFilePaths,
    required FileDomain domain,
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 이미지가 있으면 업로드
      List<String> uploadedFileUrls = [];
      if (localFilePaths.isNotEmpty) {
        final fileNames =
            localFilePaths.map((path) => path.split('/').last).toList();

        // 1) presigned url 발급
        final presignedList = await _uploader.getPresignedUrls(
          fileNames: fileNames,
          domain: domain.value,
        );

        // 2) 각 presigned url에 PUT 요청으로 실제 파일 업로드
        for (int i = 0; i < presignedList.length; i++) {
          final presignedUrl = presignedList[i].presignedUrl;
          final localPath = localFilePaths[i];
          await _uploader.uploadFileToS3(
            presignedUrl: presignedUrl,
            filePath: localPath,
          );
        }

        // 3) 업로드 완료된 파일들의 최종 url을 추출
        uploadedFileUrls = presignedList.map((e) => e.fileUrl).toList();
      }

      // 게시글 작성 API
      final postData = PostCreateRequestDto(
        beautyCategory: beautyCategory,
        title: title,
        content: content,
        fileUrls: uploadedFileUrls,
      );

      final PostModel createdPost =
          await _communityRepo.addCommunityPost(postData: postData);
      logger.i("게시글 작성 완료: ${createdPost.id}");

      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = "게시글 작성 실패: $e";
      logger.e("게시글 작성 실패: $e");
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  /// 기존 게시글 수정
  ///   - remainingUrls: 사용자가 삭제하지 않은 기존 이미지들의 URL
  ///   - localFilePaths: 새로 추가된 로컬 파일 경로 목록
  Future<bool> updatePost({
    required String postId,
    required BeautyCategory beautyCategory,
    required String title,
    required String content,
    required FileDomain domain,
    required List<String> remainingUrls, // 남길 기존 이미지 URL
    required List<String> localFilePaths, // 새로 추가된 로컬 파일
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1) 새로 추가된 이미지 S3 업로드
      List<String> newUploadedUrls = [];
      if (localFilePaths.isNotEmpty) {
        final fileNames =
            localFilePaths.map((path) => path.split('/').last).toList();

        final presignedList = await _uploader.getPresignedUrls(
          fileNames: fileNames,
          domain: domain.value,
        );

        for (int i = 0; i < presignedList.length; i++) {
          final presignedUrl = presignedList[i].presignedUrl;
          final localPath = localFilePaths[i];
          await _uploader.uploadFileToS3(
            presignedUrl: presignedUrl,
            filePath: localPath,
          );
        }

        newUploadedUrls = presignedList.map((e) => e.fileUrl).toList();
      }

      // 2) 최종적으로 서버에 보낼 fileUrls = (남길 기존 URL) + (새로 업로드된 URL)
      final finalFileUrls = [...remainingUrls, ...newUploadedUrls];

      // 3) 게시글 수정 API
      final postData = PostCreateRequestDto(
        beautyCategory: beautyCategory,
        title: title,
        content: content,
        fileUrls: finalFileUrls,
      );

      final updatedPost = await _communityRepo.updateCommunityPost(
        postId: postId,
        postData: postData,
      );

      logger.i("게시글 수정 완료: ${updatedPost.id}");

      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = "게시글 수정 실패: $e";
      logger.e("게시글 수정 실패: $e");
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }
}
