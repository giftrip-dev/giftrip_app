import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';

class PdfDownloadUtil {
  static Future<void> downloadPdf({
    required BuildContext context,
    required String assetPath,
    required String fileName,
  }) async {
    if (Platform.isAndroid) {
      await _savePdfToDownloads(context, assetPath, fileName);
    } else if (Platform.isIOS) {
      await _saveAndSharePdf(context, assetPath, fileName);
    }
  }

  static Future<void> _savePdfToDownloads(
      BuildContext context, String assetPath, String fileName) async {
    try {
      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();

      // Android Download 디렉토리 경로 얻기
      final dirs = await getExternalStorageDirectories(
        type: StorageDirectory.downloads,
      );
      String downloadsPath = dirs?.first.path ??
          '/storage/emulated/0/Download'; // 혹시 null이면 fallback

      // 고유 이름 생성
      final fullPath = await _getUniqueFileName(downloadsPath, fileName);
      final file = File(fullPath);

      await file.writeAsBytes(bytes);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('📂 다운로드 완료: $fullPath')),
      );
    } catch (e) {
      debugPrint("❌ [Android] 파일 저장 오류: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('파일 다운로드 중 오류가 발생했습니다.')),
      );
    }
  }

  // iOS는 변경 없음
  static Future<void> _saveAndSharePdf(
      BuildContext context, String assetPath, String fileName) async {
    try {
      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final filePath = path.join(tempDir.path, fileName);
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      await Share.shareXFiles([XFile(filePath)]);
      await file.delete();
    } catch (e) {
      debugPrint("❌ [iOS] 파일 저장 오류: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('파일 다운로드 중 오류가 발생했습니다.')),
      );
    }
  }

  static Future<String> _getUniqueFileName(
      String dirPath, String fileName) async {
    final candidate = path.join(dirPath, fileName);
    if (await File(candidate).exists()) {
      final ts = DateTime.now().millisecondsSinceEpoch;
      final ext = path.extension(fileName);
      final base = path.basenameWithoutExtension(fileName);
      return path.join(dirPath, '$base-$ts$ext');
    }
    return candidate;
  }
}
