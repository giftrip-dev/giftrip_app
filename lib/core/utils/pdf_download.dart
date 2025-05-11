import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';

/// PDF 다운로드/저장 유틸리티
class PdfDownloadUtil {
  /// ─────────────────────────────────────────────────────────────────────────────
  /// 1. [downloadPdf]
  ///    - 플랫폼(iOS/Android)에 따라 PDF를 저장(또는 공유)하는 메인 함수
  /// ─────────────────────────────────────────────────────────────────────────────
  ///
  /// [context]:  SnackBar 등을 띄우기 위해 필요한 BuildContext
  /// [assetPath]: 프로젝트 assets 폴더 내 PDF 경로 (예: 'assets/service-terms.pdf')
  /// [fileName]:  최종적으로 저장될 파일명 (예: 'service-terms.pdf')
  static Future<void> downloadPdf({
    required BuildContext context,
    required String assetPath,
    required String fileName,
  }) async {
    // 안드로이드: Download 폴더에 저장
    if (Platform.isAndroid) {
      await _savePdfToDownloads(context, assetPath, fileName);
    }
    // iOS: 임시 폴더에 저장 후 Share Sheet로 공유
    else if (Platform.isIOS) {
      await _saveAndSharePdf(context, assetPath, fileName);
    }
  }

  /// ─────────────────────────────────────────────────────────────────────────────
  /// 2. [_savePdfToDownloads]
  ///    - 안드로이드에서 PDF를 /Download 폴더에 저장
  /// ─────────────────────────────────────────────────────────────────────────────
  ///
  /// [context]:  SnackBar 등을 띄우기 위해 필요한 BuildContext
  /// [assetPath]: 프로젝트 assets 폴더 내 PDF 경로 (예: 'assets/service-terms.pdf')
  /// [fileName]:  저장할 파일 이름
  static Future<void> _savePdfToDownloads(
    BuildContext context,
    String assetPath,
    String fileName,
  ) async {
    try {
      // 1. assets 폴더에서 PDF 데이터를 로드
      final ByteData data = await rootBundle.load(assetPath);
      final List<int> bytes = data.buffer.asUint8List();

      // 2. 안드로이드 'Download' 폴더의 실제 경로 가져오기
      final downloadsPath =
          await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOAD,
      );

      // 3. 중복 파일명 방지를 위해 고유 파일명 생성
      final fullPath = await _getUniqueFileName(downloadsPath, fileName);
      final file = File(fullPath);

      // 4. 파일에 데이터 쓰기
      await file.writeAsBytes(bytes);

      // 로그 출력(확인용)
      debugPrint("📥 [Android] 파일 다운로드 완료: $fullPath");

      // 파일 저장 성공 시 사용자에게 안내(SnackBar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('📂 파일이 다운로드되었습니다: $fullPath')),
      );
    } catch (e) {
      // 예외 발생 시 오류 로그 및 SnackBar 표시
      debugPrint("❌ [Android] 파일 저장 오류: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('파일 다운로드 중 오류가 발생했습니다.')),
      );
    }
  }

  /// ─────────────────────────────────────────────────────────────────────────────
  /// 3. [_saveAndSharePdf]
  ///    - iOS에서 PDF를 임시 폴더에 저장 후 Share Sheet를 통해 사용자가 저장 가능
  /// ─────────────────────────────────────────────────────────────────────────────
  ///
  /// [context]:  SnackBar 등을 띄우기 위해 필요한 BuildContext
  /// [assetPath]: 프로젝트 assets 폴더 내 PDF 경로
  /// [fileName]:  저장할 파일 이름
  static Future<void> _saveAndSharePdf(
    BuildContext context,
    String assetPath,
    String fileName,
  ) async {
    try {
      // 1. assets 폴더에서 PDF 데이터를 로드
      final ByteData data = await rootBundle.load(assetPath);
      final List<int> bytes = data.buffer.asUint8List();

      // 2. iOS에서 임시 디렉토리 가져오기
      final tempDir = await getTemporaryDirectory();
      final filePath = path.join(tempDir.path, fileName);
      final file = File(filePath);

      // 3. 임시 디렉토리에 PDF 파일로 저장
      await file.writeAsBytes(bytes);

      // 4. Share Sheet 호출
      await Share.shareXFiles([XFile(filePath)]);

      // 5. 공유 후 임시 파일 삭제
      await file.delete();
    } catch (e) {
      // 예외 발생 시 오류 로그 및 SnackBar 표시
      debugPrint("❌ [iOS] 파일 저장 오류: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('파일 다운로드 중 오류가 발생했습니다.')),
      );
    }
  }

  /// ─────────────────────────────────────────────────────────────────────────────
  /// 4. [_getUniqueFileName]
  ///    - 해당 디렉토리에 동일 파일명이 이미 있다면, 타임스탬프를 붙여 새 이름으로 반환
  /// ─────────────────────────────────────────────────────────────────────────────
  ///
  /// [dirPath]:  파일이 저장될 경로 (예: /storage/emulated/0/Download)
  /// [fileName]: 원하는 파일명 (예: 'service-terms.pdf')
  static Future<String> _getUniqueFileName(
      String dirPath, String fileName) async {
    final fullPath = path.join(dirPath, fileName);

    // 이미 같은 파일명이 존재하면, 타임스탬프를 추가하여 중복 방지
    if (await File(fullPath).exists()) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ext = path.extension(fileName); // ".pdf"
      final base = path.basenameWithoutExtension(fileName); // "service-terms"
      return path.join(dirPath, '$base-$timestamp$ext');
    }

    // 중복이 없으면 그대로 반환
    return fullPath;
  }
}
