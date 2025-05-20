import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final void Function(DateTime?, DateTime?, DateTime) onRangeSelected;

  const CalendarWidget({
    super.key,
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.onRangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(const Duration(days: 365)),
      focusedDay: selectedStartDate ?? DateTime.now(),
      calendarFormat: CalendarFormat.month,
      rangeStartDay: selectedStartDate,
      rangeEndDay: selectedEndDate,
      rangeSelectionMode: RangeSelectionMode.toggledOn,
      onRangeSelected: onRangeSelected,
      headerStyle: HeaderStyle(
        headerPadding: const EdgeInsets.only(top: 10, bottom: 14),
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: title_M.copyWith(color: AppColors.calendarText),
        leftChevronIcon: const Icon(
          LucideIcons.chevronLeft,
          size: 24,
          color: AppColors.calendarText,
        ),
        leftChevronMargin: const EdgeInsets.only(left: 0),
        leftChevronPadding: const EdgeInsets.only(left: 12),
        rightChevronIcon: const Icon(
          LucideIcons.chevronRight,
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
      selectedDayPredicate: (day) {
        return selectedStartDate != null && isSameDay(selectedStartDate, day);
      },
      locale: 'ko_KR',
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: body_S.copyWith(
          color: AppColors.calendarDay,
        ),
        weekendStyle: body_S.copyWith(
          color: AppColors.calendarDay,
        ),
      ),
      startingDayOfWeek: StartingDayOfWeek.monday,
    );
  }
}
