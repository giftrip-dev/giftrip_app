import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/features/experience/models/experience_model.dart';
import 'package:giftrip/features/experience/view_models/experience_view_model.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

/// 체험 예약 바텀시트
class ExperienceReservationBottomSheet extends StatefulWidget {
  final VoidCallback? onClose;

  const ExperienceReservationBottomSheet({
    super.key,
    this.onClose,
  });

  @override
  State<ExperienceReservationBottomSheet> createState() =>
      _ExperienceReservationBottomSheetState();

  /// 바텀시트를 표시하는 정적 메서드
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 키보드가 올라왔을 때 바텀시트를 밀어올리도록
      backgroundColor: Colors.transparent,
      builder: (context) => ExperienceReservationBottomSheet(
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }
}

class _ExperienceReservationBottomSheetState
    extends State<ExperienceReservationBottomSheet> {
  // 날짜 선택 관련 변수
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  bool _isCalendarVisible = false;

  // 포맷터
  final DateFormat _dateFormat = DateFormat('yyyy년 MM월 dd일');

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
            _buildCalendar(experience),
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

    // 여기에 예약 처리 로직 추가
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${_dateFormat.format(_selectedStartDate!)} - ${_dateFormat.format(_selectedEndDate!)} 예약이 완료되었습니다.'),
        duration: const Duration(seconds: 2),
      ),
    );

    // 바텀시트 닫기
    Navigator.of(context).pop();
  }

  // 캘린더 위젯 빌더
  Widget _buildCalendar(ExperienceModel experience) {
    final today = DateTime.now();

    // 날짜 선택 범위 설정 (오늘부터 구매 가능 종료일까지)
    final firstDay = today;
    final lastDay = experience.availableTo;

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
          if (day.isBefore(experience.availableFrom) ||
              day.isAfter(experience.availableTo)) {
            return false;
          }

          // 이용 불가능 날짜 체크
          if (experience.unavailableDates != null) {
            final dateString =
                day.toIso8601String().split('T')[0]; // YYYY-MM-DD 형식
            if (experience.unavailableDates!.contains(dateString)) {
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
              if (experience.unavailableDates != null) {
                final dateString =
                    _selectedEndDate!.toIso8601String().split('T')[0];
                if (experience.unavailableDates!.contains(dateString)) {
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
                }
              }
            });
          }
        },
        locale: 'ko_KR',
      ),
    );
  }
}
