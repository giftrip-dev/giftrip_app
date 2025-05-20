import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giftrip/features/lodging/widgets/stay_option_bottom_sheet.dart';

/// 객실 선택 섹션 위젯
class LodgingSelectSection extends StatefulWidget {
  final String dateText;
  final String guestText;
  const LodgingSelectSection({
    super.key,
    required this.dateText,
    required this.guestText,
  });

  @override
  State<LodgingSelectSection> createState() => _LodgingSelectSectionState();
}

class _LodgingSelectSectionState extends State<LodgingSelectSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 제목
          Text('객실 선택', style: title_L),

          const SizedBox(height: 16),

          // 필터 바
          GestureDetector(
            onTap: () {
              StayOptionBottomSheet.show(context);
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
                    child: Text(widget.dateText, style: body_M),
                  ),
                  const Icon(
                    LucideIcons.calendarDays,
                    size: 24,
                    color: AppColors.labelStrong,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              StayOptionBottomSheet.show(context);
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
                    child: Text(widget.guestText, style: body_M),
                  ),
                  const Icon(
                    LucideIcons.user2,
                    size: 24,
                    color: AppColors.labelStrong,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
