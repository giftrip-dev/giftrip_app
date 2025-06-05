import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giftrip/features/lodging/widgets/stay_option_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/features/lodging/view_models/lodging_view_model.dart';
import 'package:giftrip/features/lodging/repositories/mock_room_data.dart';
import 'package:giftrip/features/lodging/widgets/room_list.dart';

/// 객실 선택 섹션 위젯
class RoomSelectSection extends StatefulWidget {
  final String dateText;
  final String guestText;
  const RoomSelectSection({
    super.key,
    required this.dateText,
    required this.guestText,
  });

  @override
  State<RoomSelectSection> createState() => _RoomSelectSectionState();
}

class _RoomSelectSectionState extends State<RoomSelectSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LodgingViewModel>();
    final lodging = viewModel.selectedLodging;
    final screenWidth = MediaQuery.of(context).size.width;

    final itemWidth = screenWidth;
    final itemHeight = itemWidth * (213 / 328); // 328:213 비율 적용

    if (lodging == null) return const SizedBox.shrink();

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
            onTap: () async {
              final result = await StayOptionBottomSheet.show(context);
              if (result == true && viewModel.selectedLodging != null) {
                await viewModel.fetchRoomList(
                  viewModel.selectedLodging!.id,
                  refresh: true,
                );
              }
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
            onTap: () async {
              final result = await StayOptionBottomSheet.show(context);
              if (result == true && viewModel.selectedLodging != null) {
                await viewModel.fetchRoomList(
                  viewModel.selectedLodging!.id,
                  refresh: true,
                );
              }
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
          const SizedBox(height: 12),
          if (viewModel.isRoomLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            )
          else
            RoomList(
              rooms: viewModel.roomList,
              width: itemWidth,
              height: itemHeight,
            ),
        ],
      ),
    );
  }
}
