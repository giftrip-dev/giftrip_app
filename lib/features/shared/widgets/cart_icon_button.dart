import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/features/cart/view_models/cart_view_model.dart';

/// 장바구니 아이콘 버튼 위젯
/// Badge를 통해 현재 장바구니에 담긴 아이템 개수를 표시
class CartIconButton extends StatelessWidget {
  /// 아이콘 색상 (기본값: AppColors.labelStrong)
  final Color color;

  /// 아이콘 크기
  final double size;

  const CartIconButton({
    super.key,
    this.color = AppColors.labelStrong,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartViewModel>(
      builder: (context, cartViewModel, child) {
        return Stack(
          children: [
            // 장바구니 아이콘
            Icon(
              Icons.shopping_cart_outlined,
              size: size,
              color: color,
            ),
            // 장바구니 개수 표시
            if (cartViewModel.itemCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.primarySoft,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    cartViewModel.itemCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
