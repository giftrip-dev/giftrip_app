import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum BackButtonAppBarType { complete, textCenter, textLeft, none }

class BackButtonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BackButtonAppBarType type;
  final String? title;
  final VoidCallback? onBack;
  final VoidCallback? onComplete;

  const BackButtonAppBar({
    Key? key,
    required this.type,
    this.title,
    this.onBack,
    this.onComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case BackButtonAppBarType.complete:
        return AppBar(
          leading: IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            visualDensity: VisualDensity.compact,
            icon: const Icon(LucideIcons.chevronLeft, size: 24),
            onPressed: onBack ?? () => Navigator.pop(context),
          ),
          title: Text(title ?? "",
              textAlign: TextAlign.center,
              style: subtitle_M.copyWith(color: AppColors.labelStrong)),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: onComplete,
              child: Text(
                "완료",
                style: title_S.copyWith(color: AppColors.statusClear),
              ),
            ),
          ],
        );

      case BackButtonAppBarType.textCenter:
        return AppBar(
          leading: IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            visualDensity: VisualDensity.compact,
            icon: const Icon(LucideIcons.chevronLeft, size: 24),
            onPressed: onBack ?? () => Navigator.pop(context),
          ),
          title: Text(title ?? "",
              style: title_M.copyWith(color: AppColors.labelStrong)),
          titleSpacing: 0,
        );

      case BackButtonAppBarType.textLeft:
        return AppBar(
          leading: IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            visualDensity: VisualDensity.compact,
            icon: const Icon(LucideIcons.chevronLeft, size: 24),
            onPressed: onBack ?? () => Navigator.pop(context),
          ),
          title: Text(title ?? "",
              style: subtitle_M.copyWith(color: AppColors.labelStrong)),
          titleSpacing: 0,
          centerTitle: false,
        );

      case BackButtonAppBarType.none:
        return AppBar(
          leading: IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            visualDensity: VisualDensity.compact,
            icon: const Icon(LucideIcons.chevronLeft, size: 24),
            onPressed: onBack ?? () => Navigator.pop(context),
          ),
        );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(48.0);
}
