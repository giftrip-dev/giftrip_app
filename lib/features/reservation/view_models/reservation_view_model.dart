import 'package:flutter/foundation.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/reservation/models/reservation_category.dart';
import 'package:giftrip/features/reservation/models/reservation_model.dart';
import 'package:giftrip/features/reservation/models/reservation_detail_model.dart';
import 'package:giftrip/features/reservation/repositories/reservation_repo.dart';

/// 체험 상품 뷰모델
class ReservationViewModel extends ChangeNotifier {
  final ReservationRepo _repo = ReservationRepo();

  // 상태 저장
  List<ReservationModel> _reservationList = [];
  ReservationDetailModel? _selectedReservation;
  PageMeta? _meta;
  bool _isLoading = false;
  bool _hasError = false;
  ReservationCategory? _selectedCategory;

  // 외부 접근용 Getter
  List<ReservationModel> get reservationList => _reservationList;
  ReservationDetailModel? get selectedReservation => _selectedReservation;
  PageMeta? get meta => _meta;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  ReservationCategory? get selectedCategory => _selectedCategory;

  /// 다음 페이지 번호 계산
  int? get nextPage {
    if (_meta == null) return null;
    return _meta!.currentPage < _meta!.totalPages
        ? _meta!.currentPage + 1
        : null;
  }

  /// 카테고리 변경
  Future<void> changeCategory(ReservationCategory? category) async {
    if (_selectedCategory == category) return;

    // 로딩 상태 시작
    _isLoading = true;
    _reservationList = [];
    notifyListeners();

    // 0.2초 딜레이
    await Future.delayed(const Duration(milliseconds: 200));

    _selectedCategory = category;
    await fetchReservationList(refresh: true);
  }

  /// 체험 상품 목록 조회
  Future<void> fetchReservationList({bool refresh = false}) async {
    // 이미 로딩 중이거나, 첫 로드/새로고침이 아닌데 다음 페이지가 없는 경우 리턴
    if ((!refresh && _isLoading) ||
        (!refresh && _reservationList.isNotEmpty && nextPage == null)) {
      return;
    }

    try {
      if (!refresh) {
        _isLoading = true;
        notifyListeners();
      }

      // 새로고침이거나 첫 로드인 경우 페이지 1부터 시작
      final page = refresh || _reservationList.isEmpty ? 1 : (nextPage ?? 1);

      final response = await _repo.getReservationList(
        category: _selectedCategory,
        page: page,
      );

      if (refresh || _reservationList.isEmpty) {
        _reservationList = response.items;
      } else {
        _reservationList = [..._reservationList, ...response.items];
      }
      _meta = response.meta;
      _hasError = false;
    } catch (e) {
      _hasError = true;
      logger.e('체험 상품 목록 조회 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 체험 상품 상세 정보 조회
  Future<void> fetchExperienceDetail(String id) async {
    try {
      _isLoading = true;
      _hasError = false;
      notifyListeners();

      _selectedReservation = await _repo.getReservationDetail(id);
    } catch (e) {
      _hasError = true;
      logger.e('체험 상품 상세 정보 조회 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 선택된 상품 초기화
  void clearSelectedReservation() {
    _selectedReservation = null;
    notifyListeners();
  }
}
