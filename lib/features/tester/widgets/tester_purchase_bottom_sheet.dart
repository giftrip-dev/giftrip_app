import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/core/widgets/snack_bar/custom_snack_bar.dart';
import 'package:giftrip/core/widgets/calendar/common_calendar_widget.dart';
import 'package:giftrip/features/cart/view_models/cart_view_model.dart';
import 'package:giftrip/features/payment/screens/reservation_payment_screen.dart';
import 'package:giftrip/features/payment/view_models/payment_view_model.dart';
import 'package:giftrip/features/tester/models/tester_detail_model.dart';
import 'package:giftrip/features/tester/view_models/tester_view_model.dart';
import 'package:giftrip/shared/widgets/common/quantity_selector.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

/// 체험단 구매 바텀시트
class TesterPurchaseBottomSheet extends StatefulWidget {
  final VoidCallback? onClose;

  const TesterPurchaseBottomSheet({
    super.key,
    this.onClose,
  });

  @override
  State<TesterPurchaseBottomSheet> createState() =>
      _TesterPurchaseBottomSheetState();

  /// 바텀시트를 표시하는 정적 메서드
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 키보드가 올라왔을 때 바텀시트를 밀어올리도록
      backgroundColor: Colors.transparent,
      builder: (context) => TesterPurchaseBottomSheet(
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }
}

class _TesterPurchaseBottomSheetState extends State<TesterPurchaseBottomSheet> {
  // 날짜 선택 관련 변수
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  bool _isCalendarVisible = false;

  // 수량 선택 관련 변수
  int _quantity = 1;

  // 포맷터
  final DateFormat _dateFormat = DateFormat('MM.dd(E)', 'ko_KR');

  String _formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  @override
  Widget build(BuildContext context) {
    // 체험단 상품 정보 가져오기
    final viewModel = context.watch<TesterViewModel>();
    final tester = viewModel.selectedTester;

    if (tester == null) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 (제목 + 닫기 버튼)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 제목
              Text(
                '신청하기',
                style: title_L,
              ),

              // 닫기 버튼
              GestureDetector(
                onTap: () {
                  if (widget.onClose != null) {
                    widget.onClose!();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: const SizedBox(
                  width: 24,
                  height: 24,
                  child: Icon(
                    Icons.close,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 날짜 선택 필드
          GestureDetector(
            onTap: () {
              setState(() {
                _isCalendarVisible = !_isCalendarVisible;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.line),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedStartDate != null && _selectedEndDate != null
                          ? '${_formatDate(_selectedStartDate!)} ~ ${_formatDate(_selectedEndDate!)}'
                          : '날짜를 선택해주세요',
                      style: _selectedStartDate != null
                          ? body_M
                          : body_M.copyWith(color: AppColors.labelAlternative),
                    ),
                  ),
                  const Icon(
                    LucideIcons.calendarDays,
                    size: 20,
                    color: AppColors.component,
                  ),
                ],
              ),
            ),
          ),

          // 캘린더 위젯 (토글 가능)
          if (_isCalendarVisible) ...[
            const SizedBox(height: 12),
            CommonCalendarWidget<TesterDetailModel>(
              model: tester,
              selectedStartDate: _selectedStartDate,
              selectedEndDate: _selectedEndDate,
              onRangeSelected: (start, end, focusedDay) {
                // 날짜 선택 처리
                if (start != null) {
                  // 시작일이 이용 불가능 날짜인지 체크
                  bool isStartDateUnavailable = false;
                  if (tester.unavailableDates != null) {
                    final startDateString =
                        start.toIso8601String().split('T')[0];
                    isStartDateUnavailable =
                        tester.unavailableDates!.contains(startDateString);
                  }

                  if (isStartDateUnavailable) {
                    // 시작일이 이용 불가능한 경우에만 에러 처리
                    setState(() {
                      _selectedStartDate = null;
                      _selectedEndDate = null;
                    });

                    // 토스트 메시지 표시 (바텀시트 위에 표시)
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final overlay = Overlay.of(context, rootOverlay: true);
                      final overlayEntry = OverlayEntry(
                        builder: (context) => Positioned(
                          top: MediaQuery.of(context).size.height * 0.1,
                          left: 16,
                          right: 16,
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.gray800,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    LucideIcons.info,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '선택하신 날짜는 이용할 수 없습니다. 다른 날짜를 선택해주세요.',
                                      style:
                                          body_S.copyWith(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );

                      overlay.insert(overlayEntry);

                      // 3초 후 제거
                      Future.delayed(const Duration(seconds: 3), () {
                        overlayEntry.remove();
                      });
                    });
                  } else {
                    // 시작일이 이용 가능한 경우 정상 처리
                    setState(() {
                      _selectedStartDate = start;
                      _selectedEndDate = start.add(const Duration(days: 1));
                    });
                  }
                }
              },
              getUnavailableDates: (model) => model.unavailableDates,
              getAvailableFrom: (model) => model.availableFrom,
              getAvailableTo: (model) => model.availableTo,
            ),
          ],

          // 수량 선택 위젯 (날짜가 선택된 경우에만 표시)
          if (_selectedStartDate != null && _selectedEndDate != null) ...[
            const SizedBox(height: 24),
            QuantitySelector(
              productName: tester.title,
              price: tester.finalPrice,
              quantity: _quantity,
              onQuantityChanged: (newQuantity) {
                setState(() {
                  _quantity = newQuantity;
                });
              },
            ),
          ],

          // 신청 버튼
          const SizedBox(height: 24),
          Row(
            children: [
              // 장바구니 버튼
              Expanded(
                flex: 120,
                child: CTAButton(
                  text: '장바구니',
                  type: CTAButtonType.outline,
                  size: CTAButtonSize.extraLarge,
                  onPressed:
                      _selectedStartDate != null && _selectedEndDate != null
                          ? () => _handleAddToCart(tester)
                          : null,
                  isEnabled:
                      _selectedStartDate != null && _selectedEndDate != null,
                ),
              ),
              const SizedBox(width: 8),
              // 신청하기 버튼
              Expanded(
                flex: 200,
                child: CTAButton(
                  text: '신청하기',
                  onPressed:
                      _selectedStartDate != null && _selectedEndDate != null
                          ? () {
                              // 신청 처리 로직
                              _processApplication(tester);
                            }
                          : null,
                  isEnabled:
                      _selectedStartDate != null && _selectedEndDate != null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 신청 처리 로직
  void _processApplication(TesterDetailModel tester) {
    if (_selectedStartDate == null || _selectedEndDate == null) return;

    final paymentViewModel = context.read<PaymentViewModel>();

    // 체험단 신청을 PaymentItem으로 변환
    final paymentItem = PaymentItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productId: tester.id,
      title: tester.title,
      optionName:
          '${_dateFormat.format(_selectedStartDate!)} - ${_dateFormat.format(_selectedEndDate!)}',
      thumbnailUrl: tester.thumbnailUrl,
      price: tester.finalPrice,
      quantity: _quantity,
      type: ProductItemType.experienceGroup,
      startDate: _selectedStartDate,
      endDate: _selectedEndDate,
    );

    // 결제 예정 데이터 설정
    paymentViewModel.setItems([paymentItem]);

    // 바텀시트 닫기
    Navigator.of(context).pop();

    // 예약 결제 페이지로 이동 (체험단도 예약 결제 방식 사용)
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ReservationPaymentScreen(),
      ),
    );
  }

  // 장바구니 추가
  Future<void> _handleAddToCart(TesterDetailModel tester) async {
    if (_selectedStartDate == null || _selectedEndDate == null) return;

    final cartViewModel = context.read<CartViewModel>();

    try {
      await cartViewModel.addToCart(
        tester.id,
        ProductItemType.experienceGroup,
        quantity: _quantity,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message: '체험단이 장바구니에 담겼습니다.',
            icon: Icons.shopping_cart_outlined,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message: '장바구니 담기에 실패했습니다.',
            icon: Icons.error_outline,
            textColor: AppColors.statusError,
          ),
        );
      }
    }
  }
}
