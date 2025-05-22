import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';

class LodgingFilterBar extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const LodgingFilterBar({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.lineStrong, width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.labelStrong),
            const SizedBox(width: 8),
            Expanded(
              child: text.contains('|')
                  ? RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: text
                            .split('|')
                            .asMap()
                            .entries
                            .map((entry) {
                              final isLast =
                                  entry.key == text.split('|').length - 1;
                              return [
                                TextSpan(
                                  text: entry.value,
                                  style: body_S.copyWith(
                                    color: AppColors.labelStrong,
                                  ),
                                ),
                                if (!isLast)
                                  TextSpan(
                                    text: '|',
                                    style: body_S.copyWith(
                                      color: AppColors.line,
                                    ),
                                  ),
                              ];
                            })
                            .expand((x) => x)
                            .toList(),
                      ),
                    )
                  : Text(
                      text,
                      style: body_S.copyWith(color: AppColors.labelStrong),
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
