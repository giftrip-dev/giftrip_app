import 'package:flutter/foundation.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/order_booking/models/order_booking_category.dart';
import 'package:giftrip/features/order_booking/models/order_booking_model.dart';
import 'package:giftrip/features/order_booking/models/order_booking_detail_model.dart';
import 'package:giftrip/features/order_booking/repositories/order_booking_repo.dart';

/// 체험 상품 뷰모델
class OrderBookingViewModel extends ChangeNotifier {
  final OrderBookingRepo _repo = OrderBookingRepo();

  // 상태 저장
  List<OrderBookingModel> _orderBookingList = [];
  OrderBookingDetailModel? _selectedOrderBooking;
  PageMeta? _meta;
  bool _isLoading = false;
  bool _hasError = false;
  OrderBookingCategory? _selectedCategory;

  // 외부 접근용 Getter
  List<OrderBookingModel> get orderBookingList => _orderBookingList;
  OrderBookingDetailModel? get selectedOrderBooking => _selectedOrderBooking;
  PageMeta? get meta => _meta;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  OrderBookingCategory? get selectedCategory => _selectedCategory;

  /// 다음 페이지 번호 계산
  int? get nextPage {
    if (_meta == null) return null;
    return _meta!.currentPage < _meta!.totalPages
        ? _meta!.currentPage + 1
        : null;
  }

  /// 카테고리 변경
  Future<void> changeCategory(OrderBookingCategory? category) async {
    if (_selectedCategory == category) return;

    // 로딩 상태 시작
    _isLoading = true;
    _orderBookingList = [];
    notifyListeners();

    // 0.2초 딜레이
    await Future.delayed(const Duration(milliseconds: 200));

    _selectedCategory = category;
    await fetchOrderBookingList(refresh: true);
  }

  /// 체험 상품 목록 조회
  Future<void> fetchOrderBookingList({bool refresh = false}) async {
    // 이미 로딩 중이거나, 첫 로드/새로고침이 아닌데 다음 페이지가 없는 경우 리턴
    if ((!refresh && _isLoading) ||
        (!refresh && _orderBookingList.isNotEmpty && nextPage == null)) {
      return;
    }

    try {
      if (!refresh) {
        _isLoading = true;
        notifyListeners();
      }

      // 새로고침이거나 첫 로드인 경우 페이지 1부터 시작
      final page = refresh || _orderBookingList.isEmpty ? 1 : (nextPage ?? 1);

      final response = await _repo.getOrderBookingList(
        category: _selectedCategory,
        page: page,
      );

      if (refresh || _orderBookingList.isEmpty) {
        _orderBookingList = response.items;
      } else {
        _orderBookingList = [..._orderBookingList, ...response.items];
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

      _selectedOrderBooking = await _repo.getOrderBookingDetail(id);
    } catch (e) {
      _hasError = true;
      logger.e('체험 상품 상세 정보 조회 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 선택된 상품 초기화
  void clearSelectedOrderBooking() {
    _selectedOrderBooking = null;
    notifyListeners();
  }
}
