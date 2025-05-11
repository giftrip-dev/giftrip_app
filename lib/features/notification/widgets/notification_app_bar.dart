import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myong/core/widgets/more_option_box/notification_more_option_overlay_button.dart';

class NotificationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBack;
  final VoidCallback onDeleteAll;
  final VoidCallback onReadAll;
  const NotificationAppBar({
    Key? key,
    this.title,
    this.onBack,
    required this.onDeleteAll,
    required this.onReadAll,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(LucideIcons.chevronLeft, size: 24),
        onPressed: onBack ?? () => Navigator.pop(context),
      ),
      title: Text(title ?? "",
          style: subtitle_M.copyWith(color: AppColors.labelStrong)),
      titleSpacing: 0,
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: NotificationMoreOptionOverlayButton(
            onDeleteAll: onDeleteAll,
            onReadAll: onReadAll,
          ),
        ),
      ],
    );
  }
}
