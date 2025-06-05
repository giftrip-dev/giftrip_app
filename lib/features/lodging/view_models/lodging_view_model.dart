import 'package:flutter/foundation.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/lodging/models/lodging_category.dart';
import 'package:giftrip/features/lodging/models/lodging_model.dart';
import 'package:giftrip/features/lodging/models/location.dart';
import 'package:giftrip/features/lodging/repositories/lodging_repo.dart';
import 'package:intl/intl.dart';

/// 숙소 상품 뷰모델
class LodgingViewModel extends ChangeNotifier {
  final LodgingRepo _repo = LodgingRepo();

  // 상태 저장
  List<LodgingModel> _lodgingList = [];
  LodgingModel? _selectedLodging;
  PageMeta? _meta;
  bool _isLoading = false;
  bool _hasError = false;
  LodgingCategory? _selectedCategory;
  MainLocation? _mainLocation;
  String _subLocation = '';
  String _stayOptionText = '';
  String _stayDateText = '';
  int _adultCount = 2;
  int _childCount = 0;
  DateTime? _startDate;
  DateTime? _endDate;

  // 외부 접근용 Getter
  List<LodgingModel> get lodgingList => _lodgingList;
  LodgingModel? get selectedLodging => _selectedLodging;
  PageMeta? get meta => _meta;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  LodgingCategory? get selectedCategory => _selectedCategory;
  MainLocation? get mainLocation => _mainLocation;
  String get subLocation => _subLocation;
  String get stayOptionText => _stayOptionText;
  int get adultCount => _adultCount;
  int get childCount => _childCount;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  String get stayDateText => _stayDateText;

  LodgingViewModel() {
    // 초기 카테고리 설정
    _selectedCategory = LodgingCategory.defaultCategory;

    // 초기 날짜 설정
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    _startDate = now;
    _endDate = tomorrow;
    final dateFormat = DateFormat('MM.dd(E)', 'ko_KR');
    _stayOptionText =
        '${dateFormat.format(now)}~${dateFormat.format(tomorrow)} | 성인 $_adultCount';
    _stayDateText = '${dateFormat.format(now)}~${dateFormat.format(tomorrow)}';
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
    await fetchAvailableLodgingList(refresh: true);
  }

  /// 예약가능 업체 목록 조회
  Future<void> fetchAvailableLodgingList({bool refresh = false}) async {
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

      final response = await _repo.getAvailableLodgingList(
        startDate: _startDate?.toIso8601String().split('T').first,
        endDate: _endDate?.toIso8601String().split('T').first,
        mainLocation: _mainLocation?.name,
        subLocation: _subLocation,
        occupancy: _adultCount + _childCount,
        category: _selectedCategory?.name,
        isActive: true,
        page: page,
        limit: 10,
      );

      // final response = await _repo.getLodgingList(
      //   mainLocation: _mainLocation?.name,
      //   subLocation: _subLocation,
      //   category: _selectedCategory?.name,
      //   page: page,
      //   limit: 10,
      // );

      if (refresh || _lodgingList.isEmpty) {
        _lodgingList = response.items;
      } else {
        _lodgingList = [..._lodgingList, ...response.items];
      }
      _meta = response.meta;
      _hasError = false;
    } catch (e) {
      _hasError = true;
      logger.e('숙소 상품 목록 조회 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 숙소 상품 상세 정보 조회
  Future<void> fetchLodgingDetail(String id) async {
    try {
      _isLoading = true;
      _hasError = false;
      notifyListeners();

      _selectedLodging = await _repo.getLodgingDetail(id);
    } catch (e) {
      _hasError = true;
      logger.e('숙소 상품 상세 정보 조회 실패: $e');
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

  void setLocationText(String subLocation) {
    _subLocation = subLocation;
    // subLocation에 해당하는 mainLocation 찾기
    _mainLocation = LocationManager.getLocationData()
        .firstWhere((data) => data.subLocations.contains(subLocation))
        .mainLocation;
    fetchAvailableLodgingList(refresh: true);
  }

  void setStayDates(DateTime startDate, DateTime endDate) {
    logger.d('111setStayDates: $startDate, $endDate');
    _startDate = startDate;
    _endDate = endDate;
    final dateFormat = DateFormat('MM.dd(E)', 'ko_KR');
    _stayOptionText =
        '${dateFormat.format(startDate)}~${dateFormat.format(endDate)} | 성인 $_adultCount${_childCount > 0 ? ', 아동 $_childCount' : ''}';
    _stayDateText =
        '${dateFormat.format(startDate)}~${dateFormat.format(endDate)}';
    fetchAvailableLodgingList(refresh: true);
  }

  void setGuestCount(int adultCount, int childCount) {
    logger.d('111setGuestCount: $adultCount, $childCount');
    _adultCount = adultCount;
    _childCount = childCount;

    // stayOptionText 업데이트
    if (_startDate != null && _endDate != null) {
      final dateFormat = DateFormat('MM.dd(E)', 'ko_KR');
      _stayOptionText =
          '${dateFormat.format(_startDate!)}~${dateFormat.format(_endDate!)} | 성인 $_adultCount${_childCount > 0 ? ', 아동 $_childCount' : ''}';
    }

    // UI 업데이트
    notifyListeners();

    // 데이터 새로 조회
    fetchAvailableLodgingList(refresh: true);
  }
}
