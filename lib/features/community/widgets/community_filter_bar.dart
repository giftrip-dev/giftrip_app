import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/enum/community_enum.dart';
import 'package:myong/core/utils/amplitude_logger.dart';

class CommunityFilterBar extends StatelessWidget {
  final PostSortType selectedSort;
  final ValueChanged<PostSortType> onSortChanged;

  const CommunityFilterBar({
    super.key,
    required this.selectedSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _filterButton(
            label: "최신순",
            icon: LucideIcons.history,
            sortType: PostSortType.latest,
          ),
          const SizedBox(width: 8),
          _filterButton(
            label: "인기순",
            icon: LucideIcons.flame,
            sortType: PostSortType.popular,
          ),
          const SizedBox(width: 8),
          _filterButton(
            label: "댓글순",
            icon: LucideIcons.messageCircle,
            sortType: PostSortType.comments,
          ),
        ],
      ),
    );
  }

  Widget _filterButton({
    required String label,
    required IconData icon,
    required PostSortType sortType,
  }) {
    final bool isSelected = selectedSort == sortType;

    return GestureDetector(
      onTap: () {
        AmplitudeLogger.logClickEvent(
            "community_filter_click", "${sortType}_button", "community_screen");
        onSortChanged(sortType);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.labelStrong : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.labelStrong : AppColors.lineStrong,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.labelStrong,
            ),
            const SizedBox(width: 4),
            Text(label,
                style: title_XS.copyWith(
                  color: isSelected ? Colors.white : AppColors.labelStrong,
                )),
          ],
        ),
      ),
    );
  }
}
