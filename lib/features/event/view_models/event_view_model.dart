import 'package:flutter/foundation.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/event/models/event_model.dart';
import 'package:giftrip/features/event/repositories/event_repo.dart';

/// 이벤트 뷰모델
class EventViewModel extends ChangeNotifier {
  final EventRepo _repo = EventRepo();

  // 상태 저장
  List<EventModel> _eventList = [];
  PageMeta? _meta;
  bool _isLoading = false;
  bool _hasError = false;

  // 외부 접근용 Getter
  List<EventModel> get eventList => _eventList;
  PageMeta? get meta => _meta;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  /// 다음 페이지 번호 계산
  int? get nextPage {
    if (_meta == null) return null;
    return _meta!.currentPage < _meta!.totalPages
        ? _meta!.currentPage + 1
        : null;
  }

  /// 이벤트 목록 조회
  Future<void> fetchEventList({bool refresh = false}) async {
    // 이미 로딩 중이거나, 첫 로드/새로고침이 아닌데 다음 페이지가 없는 경우 리턴
    if (_isLoading || (!refresh && _eventList.isNotEmpty && nextPage == null)) {
      return;
    }

    try {
      _isLoading = true;
      _hasError = false;
      notifyListeners();

      // 새로고침이거나 첫 로드인 경우 페이지 1부터 시작
      final page = refresh || _eventList.isEmpty ? 1 : (nextPage ?? 1);

      final response = await _repo.getEventList(page: page);

      if (refresh || _eventList.isEmpty) {
        _eventList = response.items;
      } else {
        _eventList = [..._eventList, ...response.items];
      }
      _meta = response.meta;
    } catch (e) {
      _hasError = true;
      logger.e('이벤트 목록 조회 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
