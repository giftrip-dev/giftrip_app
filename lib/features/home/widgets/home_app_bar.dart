import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/app_bar/custom_app_bar.dart';
import 'package:giftrip/features/search/screens/search_screen.dart';
import 'package:giftrip/shared/widgets/cart/cart_icon_button.dart';

/// 홈 화면 앱바
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;

  const HomeAppBar({
    this.onSearchTap,
    this.onNotificationTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      rightWidget: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 검색 버튼
          GestureDetector(
            onTap: onSearchTap ??
                () {
                  // 검색 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
            behavior: HitTestBehavior.opaque,
            child: const Icon(Icons.search, size: 24, color: Colors.black),
          ),
          const SizedBox(width: 16),
          // 장바구니 버튼
          const CartIconButton(
            color: Colors.black,
            size: 24,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
