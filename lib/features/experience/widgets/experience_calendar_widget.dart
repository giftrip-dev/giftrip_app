import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/features/experience/models/experience_model.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:table_calendar/table_calendar.dart';

/// 체험 예약용 캘린더 위젯
class ExperienceCalendarWidget extends StatelessWidget {
  final ExperienceModel experience;
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final Function(DateTime?, DateTime?, DateTime) onRangeSelected;

  const ExperienceCalendarWidget({
    super.key,
    required this.experience,
    this.selectedStartDate,
    this.selectedEndDate,
    required this.onRangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final firstDay = today;
    final lastDay = experience.availableTo;

    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lineStrong),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TableCalendar(
        firstDay: firstDay,
        lastDay: lastDay,
        focusedDay: selectedStartDate ?? today,
        calendarFormat: CalendarFormat.month,
        rangeStartDay: selectedStartDate,
        rangeEndDay: selectedEndDate,
        rangeSelectionMode: RangeSelectionMode.enforced,
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
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: body_S.copyWith(
            color: AppColors.calendarDay,
          ),
          weekendStyle: body_S.copyWith(
            color: AppColors.calendarDay,
          ),
        ),
        selectedDayPredicate: (day) {
          return isSameDay(selectedStartDate, day);
        },
        enabledDayPredicate: (day) {
          // 오늘 이전 날짜 비활성화
          if (day.isBefore(today)) {
            return false;
          }

          // 구매 가능 기간 체크
          if (day.isBefore(experience.availableFrom) ||
              day.isAfter(experience.availableTo)) {
            return false;
          }

          // 선택된 종료일인 경우 활성화 (UI 표시를 위해)
          if (selectedEndDate != null && isSameDay(selectedEndDate, day)) {
            return true;
          }

          // 이용 불가능 날짜 체크 (시작일 선택 시에만 적용)
          if (experience.unavailableDates != null) {
            final dateString =
                day.toIso8601String().split('T')[0]; // YYYY-MM-DD 형식
            if (experience.unavailableDates!.contains(dateString)) {
              return false;
            }
          }

          return true;
        },
        onRangeSelected: onRangeSelected,
        locale: 'ko_KR',
        startingDayOfWeek: StartingDayOfWeek.monday,
      ),
    );
  }
}
