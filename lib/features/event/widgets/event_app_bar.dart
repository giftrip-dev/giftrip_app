import 'package:flutter/material.dart';
import 'package:myong/core/widgets/app_bar/custom_app_bar.dart';

class EventAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EventAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      isBackButton: true,
      title: '이벤트',
      rightWidget: GestureDetector(
        onTap: () {
          // TODO: 검색 기능 구현
        },
        behavior: HitTestBehavior.opaque,
        child: const Icon(
          Icons.search,
          size: 24,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
