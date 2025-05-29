import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/constants/app_colors.dart';

class MyPageBox extends StatelessWidget {
  final String title;
  final Map<String, Map<String, dynamic>> myPageInfo;
  final bool showIcon;

  const MyPageBox({
    Key? key,
    required this.title,
    required this.myPageInfo,
    this.showIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundAlternative,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: title_S.copyWith(color: AppColors.labelStrong),
          ),
          ...myPageInfo.entries.map((entry) {
            return Column(
              children: [
                GestureDetector(
                  onTap: entry.value['onTap'],
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: body_M.copyWith(color: AppColors.label),
                        ),
                        if (showIcon)
                          const Icon(
                            LucideIcons.chevronRight,
                            color: AppColors.component,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
