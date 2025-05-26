import 'package:flutter/foundation.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/tester/models/tester_category.dart';
import 'package:giftrip/features/tester/models/tester_model.dart';
import 'package:giftrip/features/tester/models/tester_detail_model.dart';
import 'package:giftrip/features/tester/repositories/tester_repo.dart';

/// 체험단 상품 뷰모델
class TesterViewModel extends ChangeNotifier {
  final TesterRepo _repo = TesterRepo();

  // 상태 저장
  List<TesterModel> _testerList = [];
  TesterDetailModel? _selectedTester;
  PageMeta? _meta;
  bool _isLoading = false;
  bool _hasError = false;
  TesterCategory? _selectedCategory;

  // 외부 접근용 Getter
  List<TesterModel> get testerList => _testerList;
  TesterDetailModel? get selectedTester => _selectedTester;
  PageMeta? get meta => _meta;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  TesterCategory? get selectedCategory => _selectedCategory;

  /// 다음 페이지 번호 계산
  int? get nextPage {
    if (_meta == null) return null;
    return _meta!.currentPage < _meta!.totalPages
        ? _meta!.currentPage + 1
        : null;
  }

  /// 카테고리 변경
  Future<void> changeCategory(TesterCategory? category) async {
    if (_selectedCategory == category) return;

    // 로딩 상태 시작
    _isLoading = true;
    _testerList = [];
    notifyListeners();

    // 0.2초 딜레이
    await Future.delayed(const Duration(milliseconds: 200));

    _selectedCategory = category;
    await fetchTesterList(refresh: true);
  }

  /// 체험단 상품 목록 조회
  Future<void> fetchTesterList({bool refresh = false}) async {
    // 이미 로딩 중이거나, 첫 로드/새로고침이 아닌데 다음 페이지가 없는 경우 리턴
    if ((!refresh && _isLoading) ||
        (!refresh && _testerList.isNotEmpty && nextPage == null)) {
      return;
    }

    try {
      if (!refresh) {
        _isLoading = true;
        notifyListeners();
      }

      // 새로고침이거나 첫 로드인 경우 페이지 1부터 시작
      final page = refresh || _testerList.isEmpty ? 1 : (nextPage ?? 1);

      final response = await _repo.getTesterList(
        category: _selectedCategory,
        page: page,
      );

      if (refresh || _testerList.isEmpty) {
        _testerList = response.items;
      } else {
        _testerList = [..._testerList, ...response.items];
      }
      _meta = response.meta;
      _hasError = false;
    } catch (e) {
      _hasError = true;
      logger.e('체험단 상품 목록 조회 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 체험단 상품 상세 정보 조회
  Future<void> fetchTesterDetail(String id) async {
    try {
      _isLoading = true;
      _hasError = false;
      notifyListeners();

      _selectedTester = await _repo.getTesterDetail(id);
    } catch (e) {
      _hasError = true;
      logger.e('체험단 상품 상세 정보 조회 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 선택된 상품 초기화
  void clearSelectedTester() {
    _selectedTester = null;
    notifyListeners();
  }
}
