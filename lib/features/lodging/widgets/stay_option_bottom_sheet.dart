import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:giftrip/features/lodging/view_models/lodging_view_model.dart';

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

  // 포맷터
  final DateFormat _dateFormat = DateFormat('yyyy년 MM월 dd일');

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
                '날짜 선택',
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
                          ? '${_dateFormat.format(_selectedStartDate!)} - ${_dateFormat.format(_selectedEndDate!)}'
                          : '날짜를 선택해주세요',
                      style: _selectedStartDate != null
                          ? body_M
                          : body_M.copyWith(color: AppColors.labelAlternative),
                    ),
                  ),
                  const Icon(
                    LucideIcons.calendar,
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
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _selectedStartDate ?? DateTime.now(),
              calendarFormat: CalendarFormat.month,
              rangeStartDay: _selectedStartDate,
              rangeEndDay: _selectedEndDate,
              rangeSelectionMode: RangeSelectionMode.toggledOn,
              onRangeSelected: (start, end, focusedDay) {
                setState(() {
                  _selectedStartDate = start;
                  _selectedEndDate = end;
                });
              },
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: title_S,
              ),
              calendarStyle: CalendarStyle(
                defaultDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                outsideDaysVisible: false,
                weekendTextStyle:
                    body_S.copyWith(color: AppColors.calendarText),
                todayDecoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: AppColors.labelStrong),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                todayTextStyle: body_S.copyWith(color: AppColors.calendarText),
                selectedDecoration: BoxDecoration(
                  color: AppColors.primaryStrong,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                rangeStartDecoration: BoxDecoration(
                  color: AppColors.primaryStrong,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                rangeEndDecoration: BoxDecoration(
                  color: AppColors.primaryStrong,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                withinRangeDecoration: BoxDecoration(
                  color: AppColors.calendarSelected,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                rowDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                markerDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                holidayDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                outsideDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                weekendDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                disabledDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                disabledTextStyle:
                    body_S.copyWith(color: AppColors.labelAssistive),
                rangeHighlightColor: AppColors.calendarSelected,
              ),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedStartDate, day);
              },
              locale: 'ko_KR',
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
