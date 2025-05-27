import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/core/widgets/modal/two_button_modal.dart';
import 'package:giftrip/features/delivery/models/delivery_detail_model.dart';
import 'package:giftrip/features/delivery/models/delivery_model.dart';
import 'package:giftrip/features/delivery/models/delivery_status.dart';
import 'package:giftrip/features/delivery/repositories/delivery_repo.dart';

/// 체험 상품 뷰모델
class DeliveryViewModel extends ChangeNotifier {
  final DeliveryRepo _repo = DeliveryRepo();

  // 상태 저장
  List<DeliveryModel> _deliveryList = [];
  DeliveryDetailModel? _deliveryDetail;
  PageMeta? _meta;
  bool _isLoading = false;
  bool _hasError = false;
  DeliveryStatus? _selectedStatus;
  bool _isCanceling = false; // 취소 진행 중 상태

  // 외부 접근용 Getter
  List<DeliveryModel> get deliveryList => _deliveryList;
  DeliveryDetailModel? get deliveryDetail => _deliveryDetail;
  PageMeta? get meta => _meta;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  DeliveryStatus? get selectedStatus => _selectedStatus;
  bool get isCanceling => _isCanceling;

  /// 다음 페이지 번호 계산
  int? get nextPage {
    if (_meta == null) return null;
    return _meta!.currentPage < _meta!.totalPages
        ? _meta!.currentPage + 1
        : null;
  }

  /// 체험 상품 목록 조회
  Future<void> fetchDeliveryList({bool refresh = false}) async {
    // 이미 로딩 중이거나, 첫 로드/새로고침이 아닌데 다음 페이지가 없는 경우 리턴
    if ((!refresh && _isLoading) ||
        (!refresh && _deliveryList.isNotEmpty && nextPage == null)) {
      return;
    }

    try {
      if (!refresh) {
        _isLoading = true;
        notifyListeners();
      }

      // 새로고침이거나 첫 로드인 경우 페이지 1부터 시작
      final page = refresh || _deliveryList.isEmpty ? 1 : (nextPage ?? 1);

      final response = await _repo.getDeliveryList(
        status: _selectedStatus,
        page: page,
      );

      if (refresh || _deliveryList.isEmpty) {
        _deliveryList = response.items;
      } else {
        _deliveryList = [..._deliveryList, ...response.items];
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

      _deliveryDetail = await _repo.getDeliveryDetail(id);
    } catch (e) {
      _hasError = true;
      logger.e('체험 상품 상세 정보 조회 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 예약/구매 취소
  Future<bool> _cancelDelivery(String id, {String? reason}) async {
    try {
      _isCanceling = true;
      notifyListeners();

      // 취소 API 호출
      await _repo.cancelDelivery(id, reason: reason);

      // 목록에서 해당 아이템 찾아서 상태 업데이트
      final index = _deliveryList.indexWhere((item) => item.id == id);
      if (index != -1) {
        final updatedItem = _deliveryList[index];
        _deliveryList[index] = DeliveryModel(
          id: updatedItem.id,
          title: updatedItem.title,
          thumbnailUrl: updatedItem.thumbnailUrl,
          originalPrice: updatedItem.originalPrice,
          finalPrice: updatedItem.finalPrice,
          deliveryStatus: updatedItem.deliveryStatus,
          paidAt: updatedItem.paidAt,
          option: updatedItem.option,
          quantity: updatedItem.quantity,
        );
      }

      // 선택된 상품이 있다면 그것도 업데이트
      if (_deliveryDetail?.deliveryNumber == id) {
        _deliveryDetail = DeliveryDetailModel(
          id: id,
          deliveryNumber: _deliveryDetail!.deliveryNumber,
          deliveryStatus: _deliveryDetail!.deliveryStatus,
          product: _deliveryDetail!.product,
          shippingFee: _deliveryDetail!.shippingFee,
          invoiceNumber: _deliveryDetail!.invoiceNumber,
          ordererName: _deliveryDetail!.ordererName,
          ordererPhone: _deliveryDetail!.ordererPhone,
          ordererEmail: _deliveryDetail!.ordererEmail,
          recipientName: _deliveryDetail!.recipientName,
          recipientPhone: _deliveryDetail!.recipientPhone,
          address: _deliveryDetail!.address,
          addressDetail: _deliveryDetail!.addressDetail,
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
      BuildContext context, DeliveryModel delivery) async {
    final success = await _cancelDelivery(delivery.id);

    if (context.mounted) {
      if (success) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) => TwoButtonModal(
            title: '취소가 완료되었습니다',
            desc:
                '${delivery.deliveryStatus == DeliveryStatus.preparing ? '구매' : '예약'}금 환불 기간은 \n 카드사 영업일 기준 2~3일 정도 소요됩니다.',
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
  void clearSelectedDelivery() {
    _deliveryDetail = null;
    notifyListeners();
  }
}
