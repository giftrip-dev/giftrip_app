import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';

/// 공통 캘린더 위젯
/// T는 캘린더에서 사용할 모델 타입 (ExperienceModel, TesterDetailModel 등)
class CommonCalendarWidget<T> extends StatefulWidget {
  final T model;
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final Function(DateTime?, DateTime?, DateTime) onRangeSelected;
  final List<String>? Function(T) getUnavailableDates;
  final DateTime Function(T) getAvailableFrom;
  final DateTime Function(T) getAvailableTo;

  const CommonCalendarWidget({
    super.key,
    required this.model,
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.onRangeSelected,
    required this.getUnavailableDates,
    required this.getAvailableFrom,
    required this.getAvailableTo,
  });

  @override
  State<CommonCalendarWidget<T>> createState() =>
      _CommonCalendarWidgetState<T>();
}

class _CommonCalendarWidgetState<T> extends State<CommonCalendarWidget<T>> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;

  @override
  void initState() {
    super.initState();
    _firstDay = widget.getAvailableFrom(widget.model);
    _lastDay = widget.getAvailableTo(widget.model);

    // focusedDay를 firstDay와 lastDay 범위 내에서 설정
    final now = DateTime.now();
    if (now.isBefore(_firstDay)) {
      _focusedDay = _firstDay;
    } else if (now.isAfter(_lastDay)) {
      _focusedDay = _lastDay;
    } else {
      _focusedDay = now;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lineStrong),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TableCalendar<DateTime>(
        firstDay: _firstDay,
        lastDay: _lastDay,
        focusedDay: _focusedDay,
        calendarFormat: CalendarFormat.month,
        rangeStartDay: widget.selectedStartDate,
        rangeEndDay: widget.selectedEndDate,
        startingDayOfWeek: StartingDayOfWeek.monday,
        locale: 'ko_KR',
        onDaySelected: (selectedDay, focusedDay) {
          // 단일 날짜 선택 시 처리
          widget.onRangeSelected(selectedDay, selectedDay, focusedDay);
        },
        onRangeSelected: widget.onRangeSelected,
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
        },
        headerStyle: HeaderStyle(
          headerPadding: const EdgeInsets.only(top: 10, bottom: 14),
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: title_M.copyWith(color: AppColors.calendarText),
          leftChevronIcon: const Icon(
            Icons.chevron_left,
            size: 24,
            color: AppColors.calendarText,
          ),
          leftChevronMargin: const EdgeInsets.only(left: 0),
          leftChevronPadding: const EdgeInsets.only(left: 12),
          rightChevronIcon: const Icon(
            Icons.chevron_right,
            size: 24,
            color: AppColors.calendarText,
          ),
          rightChevronMargin: const EdgeInsets.only(right: 0),
          rightChevronPadding: const EdgeInsets.only(right: 12),
        ),
        calendarStyle: CalendarStyle(
          defaultDecoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8),
          ),
          defaultTextStyle: body_S.copyWith(
            color: AppColors.calendarText,
          ),
          outsideDaysVisible: true,
          weekendTextStyle: body_S.copyWith(color: AppColors.calendarText),
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
          disabledTextStyle: body_S.copyWith(color: AppColors.calendarDisabled),
          rangeHighlightColor: AppColors.calendarSelected,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: body_S.copyWith(
            color: AppColors.calendarDay,
          ),
          weekendStyle: body_S.copyWith(
            color: AppColors.calendarDay,
          ),
        ),
        enabledDayPredicate: (day) {
          // 이용 불가능 날짜 체크
          final unavailableDates = widget.getUnavailableDates(widget.model);
          if (unavailableDates != null) {
            final dayString = day.toIso8601String().split('T')[0];
            if (unavailableDates.contains(dayString)) {
              return false;
            }
          }

          // 과거 날짜는 선택 불가
          final today = DateTime.now();
          if (day.isBefore(today)) {
            return false;
          }

          // 구매 가능 기간 체크
          final availableFrom = widget.getAvailableFrom(widget.model);
          final availableTo = widget.getAvailableTo(widget.model);
          if (day.isBefore(availableFrom) || day.isAfter(availableTo)) {
            return false;
          }

          return true;
        },
        rangeSelectionMode: RangeSelectionMode.enforced,
      ),
    );
  }
}
