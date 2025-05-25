import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/features/experience/models/experience_model.dart';
import 'package:giftrip/features/experience/view_models/experience_view_model.dart';
import 'package:giftrip/features/experience/widgets/experience_calendar_widget.dart';
import 'package:giftrip/features/payment/screens/reservation_payment_screen.dart';
import 'package:giftrip/features/payment/view_models/payment_view_model.dart';
import 'package:giftrip/features/shared/widgets/quantity_selector.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

/// 체험 예약 바텀시트
class ExperiencePurchaseBottomSheet extends StatefulWidget {
  final VoidCallback? onClose;

  const ExperiencePurchaseBottomSheet({
    super.key,
    this.onClose,
  });

  @override
  State<ExperiencePurchaseBottomSheet> createState() =>
      _ExperiencePurchaseBottomSheetState();

  /// 바텀시트를 표시하는 정적 메서드
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 키보드가 올라왔을 때 바텀시트를 밀어올리도록
      backgroundColor: Colors.transparent,
      builder: (context) => ExperiencePurchaseBottomSheet(
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }
}

class _ExperiencePurchaseBottomSheetState
    extends State<ExperiencePurchaseBottomSheet> {
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
    // 체험 상품 정보 가져오기
    final viewModel = context.watch<ExperienceViewModel>();
    final experience = viewModel.selectedExperience;

    if (experience == null) {
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
                '예약하기',
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
            ExperienceCalendarWidget(
              experience: experience,
              selectedStartDate: _selectedStartDate,
              selectedEndDate: _selectedEndDate,
              onRangeSelected: (start, end, focusedDay) {
                // 날짜 선택 처리
                if (start != null) {
                  // 시작일이 이용 불가능 날짜인지 체크
                  bool isStartDateUnavailable = false;
                  if (experience.unavailableDates != null) {
                    final startDateString =
                        start.toIso8601String().split('T')[0];
                    isStartDateUnavailable =
                        experience.unavailableDates!.contains(startDateString);
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
            ),
          ],

          // 수량 선택 위젯 (날짜가 선택된 경우에만 표시)
          if (_selectedStartDate != null && _selectedEndDate != null) ...[
            const SizedBox(height: 24),
            QuantitySelector(
              productName: experience.title,
              price: experience.finalPrice,
              quantity: _quantity,
              onQuantityChanged: (newQuantity) {
                setState(() {
                  _quantity = newQuantity;
                });
              },
            ),
          ],

          // 예약 버튼
          const SizedBox(height: 24),
          CTAButton(
            text: '예약하기',
            onPressed: _selectedStartDate != null && _selectedEndDate != null
                ? () {
                    // 예약 처리 로직
                    _processReservation(experience);
                  }
                : null,
            isEnabled: _selectedStartDate != null && _selectedEndDate != null,
          ),
        ],
      ),
    );
  }

  // 예약 처리 로직
  void _processReservation(ExperienceModel experience) {
    if (_selectedStartDate == null || _selectedEndDate == null) return;

    final paymentViewModel = context.read<PaymentViewModel>();

    // 체험 예약을 PaymentItem으로 변환
    final paymentItem = PaymentItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productId: experience.id,
      title: experience.title,
      optionName:
          '${_dateFormat.format(_selectedStartDate!)} - ${_dateFormat.format(_selectedEndDate!)}',
      thumbnailUrl: experience.thumbnailUrl,
      price: experience.finalPrice,
      quantity: _quantity,
      type: ProductItemType.experience,
      startDate: _selectedStartDate,
      endDate: _selectedEndDate,
    );

    // 결제 예정 데이터 설정
    paymentViewModel.setItems([paymentItem]);

    // 바텀시트 닫기
    Navigator.of(context).pop();

    // 예약 결제 페이지로 이동
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ReservationPaymentScreen(),
      ),
    );
  }
}
