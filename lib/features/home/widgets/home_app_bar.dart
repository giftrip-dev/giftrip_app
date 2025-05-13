import 'package:flutter/material.dart';
import 'package:myong/core/widgets/app_bar/custom_app_bar.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      rightWidget: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 검색
          GestureDetector(
            onTap: () => {},
            behavior: HitTestBehavior.opaque,
            child: const Icon(Icons.search, size: 25, color: Colors.black),
          ),
          const SizedBox(width: 24),
          // 장바구니
          GestureDetector(
            onTap: () => {},
            behavior: HitTestBehavior.opaque,
            child: const Icon(Icons.shopping_cart_outlined,
                size: 24, color: Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
