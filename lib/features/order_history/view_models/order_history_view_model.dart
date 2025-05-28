import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/core/widgets/modal/two_button_modal.dart';
import 'package:giftrip/features/order_history/models/order_history_model.dart';
import 'package:giftrip/features/order_history/repositories/order_history_repo.dart';
import 'package:giftrip/features/payment/repositories/payment_repo.dart';

/// 구매 내역 뷰모델
class OrderHistoryViewModel extends ChangeNotifier {
  final OrderHistoryRepo _repo = OrderHistoryRepo();
  final PaymentRepo _paymentRepo = PaymentRepo();

  // 상태 저장
  List<OrderHistoryModel> _orderBookingList = [];
  OrderHistoryModel? _selectedOrderBooking;
  PageMeta? _meta;
  bool _isLoading = false;
  bool _hasError = false;
  ProductItemType? _selectedCategory;
  bool _isCanceling = false; // 취소 진행 중 상태

  // 외부 접근용 Getter
  List<OrderHistoryModel> get orderBookingList => _orderBookingList;
  OrderHistoryModel? get selectedOrderBooking => _selectedOrderBooking;
  PageMeta? get meta => _meta;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  ProductItemType? get selectedCategory => _selectedCategory;
  bool get isCanceling => _isCanceling;

  /// 다음 페이지 번호 계산
  int? get nextPage {
    if (_meta == null) return null;
    return _meta!.currentPage < _meta!.totalPages
        ? _meta!.currentPage + 1
        : null;
  }

  /// 카테고리 변경
  Future<void> changeCategory(ProductItemType? category) async {
    if (_selectedCategory == category) return;

    // 로딩 상태 시작
    _isLoading = true;
    _orderBookingList = [];
    notifyListeners();

    // 0.2초 딜레이
    await Future.delayed(const Duration(milliseconds: 200));

    _selectedCategory = category;
    await fetchOrderHistoryList(refresh: true);
  }

  /// 구매 목록 조회
  Future<void> fetchOrderHistoryList({bool refresh = false}) async {
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

  /// 예약/구매 취소
  Future<bool> _cancelOrderBooking(
    String id,
    String transactionId,
  ) async {
    try {
      _isCanceling = true;
      notifyListeners();

      // 2. 결제 취소 API 호출
      await _paymentRepo.cancelPayment(transactionId);

      // 목록에서 해당 아이템 찾아서 상태 업데이트
      final index = _orderBookingList.indexWhere((item) => item.id == id);
      if (index != -1) {
        final updatedItem = _orderBookingList[index];
        _orderBookingList[index] = OrderHistoryModel(
          id: updatedItem.id,
          orderName: updatedItem.orderName,
          items: updatedItem.items,
          totalAmount: updatedItem.totalAmount,
          progress: OrderBookingProgress.canceled, // 상태를 canceled로 변경
          paidAt: updatedItem.paidAt,
          transactionId: updatedItem.transactionId,
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      logger.e('예약/구매 취소 실패: $e');
      return false;
    } finally {
      _isCanceling = false;
      notifyListeners();
    }
  }

  /// 예약/구매 취소 처리
  Future<void> handleCancel(
      BuildContext context, OrderHistoryModel orderBooking) async {
    final success = await _cancelOrderBooking(
      orderBooking.id,
      orderBooking.transactionId,
    );

    if (context.mounted) {
      if (success) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) => TwoButtonModal(
            title: '취소가 완료되었습니다',
            desc:
                '${orderBooking.items.first.category == ProductItemType.product ? '구매' : '예약'}금 환불 기간은 \n 카드사 영업일 기준 2~3일 정도 소요됩니다.',
            cancelText: '닫기',
            confirmText: '확인',
            onConfirm: () => Navigator.of(context).pop(),
          ),
        );
      } else {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) => TwoButtonModal(
            title: '취소 실패',
            desc: '취소 중 오류가 발생했습니다. 다시 시도해주세요.',
            cancelText: '닫기',
            confirmText: '확인',
            onConfirm: () => Navigator.of(context).pop(),
          ),
        );
      }
    }
  }

  /// 선택된 상품 초기화
  void clearSelectedOrderBooking() {
    _selectedOrderBooking = null;
    notifyListeners();
  }
}
