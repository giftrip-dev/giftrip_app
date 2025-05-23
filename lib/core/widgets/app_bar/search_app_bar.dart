import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/app_bar/custom_app_bar.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const SearchAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      isBackButton: true,
      onBackPressed: onBackPressed,
      title: title,
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
