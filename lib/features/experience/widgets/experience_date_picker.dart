import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/features/experience/models/experience_model.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:table_calendar/table_calendar.dart';

class ExperienceDatePicker extends StatefulWidget {
  final ExperienceModel experience;
  final void Function(DateTime startDate, DateTime endDate)? onDateSelected;

  const ExperienceDatePicker({
    super.key,
    required this.experience,
    this.onDateSelected,
  });

  @override
  State<ExperienceDatePicker> createState() => _ExperienceDatePickerState();
}

class _ExperienceDatePickerState extends State<ExperienceDatePicker> {
  // 날짜 선택 관련 변수
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  bool _isCalendarVisible = false;

  // 포맷터
  final DateFormat _dateFormat = DateFormat('yyyy년 MM월 dd일');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
          _buildCalendar(),
        ],
      ],
    );
  }

  // 캘린더 위젯 빌더
  Widget _buildCalendar() {
    final today = DateTime.now();

    // 날짜 선택 범위 설정 (오늘부터 구매 가능 종료일까지)
    final firstDay = today;
    final lastDay = widget.experience.availableTo;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TableCalendar(
        firstDay: firstDay,
        lastDay: lastDay,
        focusedDay: _selectedStartDate ?? today,
        calendarFormat: CalendarFormat.month,
        rangeStartDay: _selectedStartDate,
        rangeEndDay: _selectedEndDate,
        rangeSelectionMode: RangeSelectionMode.enforced,
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: title_S,
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: body_S.copyWith(color: AppColors.statusError),
          todayDecoration: BoxDecoration(
            color: AppColors.primaryAlternative,
            shape: BoxShape.circle,
          ),
          todayTextStyle: body_S.copyWith(color: AppColors.primaryStrong),
          selectedDecoration: BoxDecoration(
            color: AppColors.primaryStrong,
            shape: BoxShape.circle,
          ),
          rangeStartDecoration: BoxDecoration(
            color: AppColors.primaryStrong,
            shape: BoxShape.circle,
          ),
          rangeEndDecoration: BoxDecoration(
            color: AppColors.primaryStrong,
            shape: BoxShape.circle,
          ),
          rangeHighlightColor: AppColors.primaryAlternative,
          disabledTextStyle: body_S.copyWith(color: AppColors.labelAssistive),
        ),
        selectedDayPredicate: (day) {
          return isSameDay(_selectedStartDate, day);
        },
        enabledDayPredicate: (day) {
          // 오늘 이전 날짜 비활성화
          if (day.isBefore(today)) {
            return false;
          }

          // 구매 가능 기간 체크
          if (day.isBefore(widget.experience.availableFrom) ||
              day.isAfter(widget.experience.availableTo)) {
            return false;
          }

          // 이용 불가능 날짜 체크
          if (widget.experience.unavailableDates != null) {
            final dateString =
                day.toIso8601String().split('T')[0]; // YYYY-MM-DD 형식
            if (widget.experience.unavailableDates!.contains(dateString)) {
              return false;
            }
          }

          return true;
        },
        onRangeSelected: (start, end, focusedDay) {
          // 날짜 선택 처리
          if (start != null) {
            // 시작일 선택
            setState(() {
              _selectedStartDate = start;

              // 종료일은 시작일 + 1일로 설정
              _selectedEndDate = start.add(const Duration(days: 1));

              // 이용 불가능 날짜 체크
              if (widget.experience.unavailableDates != null) {
                final dateString =
                    _selectedEndDate!.toIso8601String().split('T')[0];
                if (widget.experience.unavailableDates!.contains(dateString)) {
                  // 토스트 메시지 표시
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('구매 불가 날짜가 포함되어 있습니다. 다른 일정을 선택해주세요.'),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  // 선택 초기화
                  _selectedStartDate = null;
                  _selectedEndDate = null;
                } else {
                  // 날짜 선택 콜백 호출
                  widget.onDateSelected
                      ?.call(_selectedStartDate!, _selectedEndDate!);
                }
              } else {
                // 날짜 선택 콜백 호출
                widget.onDateSelected
                    ?.call(_selectedStartDate!, _selectedEndDate!);
              }
            });
          }
        },
        locale: 'ko_KR',
      ),
    );
  }
}
