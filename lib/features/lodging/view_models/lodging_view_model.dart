import 'package:flutter/foundation.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/lodging/models/lodging_category.dart';
import 'package:giftrip/features/lodging/models/lodging_model.dart';
import 'package:giftrip/features/lodging/models/lodging_detail_model.dart';
import 'package:giftrip/features/lodging/repositories/lodging_repo.dart';
import 'package:intl/intl.dart';

/// 숙박 상품 뷰모델
class LodgingViewModel extends ChangeNotifier {
  final LodgingRepo _repo = LodgingRepo();

  // 상태 저장
  List<LodgingModel> _lodgingList = [];
  LodgingDetailModel? _selectedLodging;
  PageMeta? _meta;
  bool _isLoading = false;
  bool _hasError = false;
  LodgingCategory? _selectedCategory;
  String _locationText = '강남/역삼/삼성';
  String _stayOptionText = '';
  int _adultCount = 2;
  int _childCount = 0;

  // 외부 접근용 Getter
  List<LodgingModel> get lodgingList => _lodgingList;
  LodgingDetailModel? get selectedLodging => _selectedLodging;
  PageMeta? get meta => _meta;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  LodgingCategory? get selectedCategory => _selectedCategory;
  String get locationText => _locationText;
  String get stayOptionText => _stayOptionText;
  int get adultCount => _adultCount;
  int get childCount => _childCount;

  LodgingViewModel() {
    // 초기 날짜 설정
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    final dateFormat = DateFormat('MM.dd(E)', 'ko_KR');
    _stayOptionText =
        '${dateFormat.format(now)}~${dateFormat.format(tomorrow)} | 성인 $_adultCount명';
  }

  /// 다음 페이지 번호 계산
  int? get nextPage {
    if (_meta == null) return null;
    return _meta!.currentPage < _meta!.totalPages
        ? _meta!.currentPage + 1
        : null;
  }

  /// 카테고리 변경
  Future<void> changeCategory(LodgingCategory? category) async {
    if (_selectedCategory == category) return;

    // 로딩 상태 시작
    _isLoading = true;
    _lodgingList = [];
    notifyListeners();

    // 0.2초 딜레이
    await Future.delayed(const Duration(milliseconds: 200));

    _selectedCategory = category;
    await fetchLodgingList(refresh: true);
  }

  /// 숙박 상품 목록 조회
  Future<void> fetchLodgingList({bool refresh = false}) async {
    // 이미 로딩 중이거나, 첫 로드/새로고침이 아닌데 다음 페이지가 없는 경우 리턴
    if ((!refresh && _isLoading) ||
        (!refresh && _lodgingList.isNotEmpty && nextPage == null)) {
      return;
    }

    try {
      if (!refresh) {
        _isLoading = true;
        notifyListeners();
      }

      // 새로고침이거나 첫 로드인 경우 페이지 1부터 시작
      final page = refresh || _lodgingList.isEmpty ? 1 : (nextPage ?? 1);

      final response = await _repo.getLodgingList(
        category: _selectedCategory,
        page: page,
      );

      if (refresh || _lodgingList.isEmpty) {
        _lodgingList = response.items;
      } else {
        _lodgingList = [..._lodgingList, ...response.items];
      }
      _meta = response.meta;
      _hasError = false;
    } catch (e) {
      _hasError = true;
      logger.e('숙박 상품 목록 조회 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 숙박 상품 상세 정보 조회
  Future<void> fetchLodgingDetail(String id) async {
    try {
      _isLoading = true;
      _hasError = false;
      notifyListeners();

      _selectedLodging = await _repo.getLodgingDetail(id);
    } catch (e) {
      _hasError = true;
      logger.e('숙박 상품 상세 정보 조회 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 선택된 상품 초기화
  void clearSelectedLodging() {
    _selectedLodging = null;
    notifyListeners();
  }

  void setLocationText(String text) {
    _locationText = text;
    notifyListeners();
  }

  void setStayDates(DateTime startDate, DateTime endDate) {
    final dateFormat = DateFormat('MM.dd(E)', 'ko_KR');
    _stayOptionText =
        '${dateFormat.format(startDate)}~${dateFormat.format(endDate)} | 성인 $_adultCount명${_childCount > 0 ? ', 아동 $_childCount명' : ''}';
    notifyListeners();
  }

  void setGuestCount(int adultCount, int childCount) {
    _adultCount = adultCount;
    _childCount = childCount;
    // 현재 선택된 날짜가 있다면 stayOptionText 업데이트
    if (_stayOptionText.isNotEmpty) {
      final now = DateTime.now();
      final tomorrow = now.add(const Duration(days: 1));
      setStayDates(now, tomorrow);
    }
  }
}
