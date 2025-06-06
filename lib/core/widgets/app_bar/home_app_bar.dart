import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/app_bar/custom_app_bar.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const HomeAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      isBackButton: true,
      title: title,
      rightWidget: GestureDetector(
        onTap: () {
          // TODO: 검색 기능 구현
        },
        behavior: HitTestBehavior.opaque,
        child: const Icon(
          LucideIcons.home,
          size: 24,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
