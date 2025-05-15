import 'package:flutter/material.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/features/notice/models/notice_model.dart';
import 'package:giftrip/features/notice/repositories/notice_repo.dart';

class NoticeViewModel extends ChangeNotifier {
  final NoticeRepo _noticeRepo = NoticeRepo();

  // 상태
  List<NoticeModel> _noticeList = [];
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMore = true;

  // Getter
  List<NoticeModel> get noticeList => _noticeList;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  /// 📌 공지사항 목록 조회
  Future<void> fetchNoticeList({int page = 1}) async {
    if (!_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _noticeRepo.getNoticeList(page: page);
      if (page == 1) {
        _noticeList = response.items; // 첫 페이지면 기존 데이터 초기화
      } else {
        _noticeList.addAll(response.items); // 다음 페이지 데이터 추가
      }

      // 페이지네이션 정보 업데이트
      _currentPage = response.meta.currentPage;
      _hasMore = _currentPage < response.meta.totalPages;

      notifyListeners();
    } catch (e) {
      logger.e('공지사항 불러오기 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
