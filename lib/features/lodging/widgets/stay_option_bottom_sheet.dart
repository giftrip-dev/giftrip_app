import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/features/lodging/view_models/lodging_view_model.dart';
import 'package:giftrip/features/lodging/widgets/calendar_widget.dart';
import 'package:giftrip/features/lodging/widgets/guest_widget.dart';

/// 숙박 옵션 바텀시트
class StayOptionBottomSheet extends StatefulWidget {
  final VoidCallback? onClose;

  const StayOptionBottomSheet({
    super.key,
    this.onClose,
  });

  @override
  State<StayOptionBottomSheet> createState() => _StayOptionBottomSheetState();

  /// 바텀시트를 표시하는 정적 메서드
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StayOptionBottomSheet(
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }
}

class _StayOptionBottomSheetState extends State<StayOptionBottomSheet> {
  // 날짜 선택 관련 변수
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  bool _isCalendarVisible = false;
  bool _isGuestVisible = false;
  int _adultCount = 2;
  int _childCount = 0;

  // 포맷터
  final DateFormat _dateFormat = DateFormat('MM.dd(E)', 'ko_KR');

  String _formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  @override
  void initState() {
    super.initState();
    // ViewModel의 초기값 가져오기
    final viewModel = context.read<LodgingViewModel>();
    _adultCount = viewModel.adultCount;
    _childCount = viewModel.childCount;

    // ViewModel의 날짜 값이 있으면 사용하고, 없으면 기본값 설정
    _selectedStartDate = viewModel.startDate ?? DateTime.now();
    _selectedEndDate =
        viewModel.endDate ?? DateTime.now().add(const Duration(days: 1));
  }

  @override
  Widget build(BuildContext context) {
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
                '날짜 인원 선택',
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
                if (_isCalendarVisible) _isGuestVisible = false;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.lineStrong),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedStartDate != null && _selectedEndDate != null
                          ? '${_formatDate(_selectedStartDate!)}~${_formatDate(_selectedEndDate!)}'
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
          const SizedBox(height: 12),
          // 인원 선택 필드
          GestureDetector(
            onTap: () {
              setState(() {
                _isGuestVisible = !_isGuestVisible;
                if (_isGuestVisible) _isCalendarVisible = false;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.lineStrong),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child:
                        Text('성인 $_adultCount, 아동 $_childCount', style: body_M),
                  ),
                  const Icon(
                    LucideIcons.user,
                    size: 20,
                    color: AppColors.component,
                  ),
                ],
              ),
            ),
          ),

          // 캘린더 위젯 (토글 가능)
          if (_isCalendarVisible) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.lineStrong),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CalendarWidget(
                selectedStartDate: _selectedStartDate,
                selectedEndDate: _selectedEndDate,
                onRangeSelected: (start, end, focusedDay) {
                  setState(() {
                    _selectedStartDate = start;
                    _selectedEndDate = end;
                  });
                },
              ),
            ),
          ],

          // 인원 선택 위젯 (토글 가능)
          if (_isGuestVisible) ...[
            const SizedBox(height: 8),
            GuestWidget(
              adultCount: _adultCount,
              childCount: _childCount,
              onAdultChanged: (val) {
                setState(() {
                  _adultCount = val;
                });
                context
                    .read<LodgingViewModel>()
                    .setGuestCount(_adultCount, _childCount);
              },
              onChildChanged: (val) {
                setState(() {
                  _childCount = val;
                });
                context
                    .read<LodgingViewModel>()
                    .setGuestCount(_adultCount, _childCount);
              },
            ),
          ],

          // 예약 버튼
          const SizedBox(height: 24),
          CTAButton(
            text: '확인',
            onPressed: _selectedStartDate != null && _selectedEndDate != null
                ? () {
                    final viewModel = context.read<LodgingViewModel>();
                    viewModel.setStayDates(
                        _selectedStartDate!, _selectedEndDate!);
                    viewModel.setGuestCount(_adultCount, _childCount);

                    Navigator.pop(context);
                  }
                : null,
            isEnabled: _selectedStartDate != null && _selectedEndDate != null,
          ),
        ],
      ),
    );
  }
}
