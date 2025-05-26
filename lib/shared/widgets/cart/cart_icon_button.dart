import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/core/widgets/snack_bar/custom_snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/features/cart/view_models/cart_view_model.dart';
import 'package:giftrip/features/root/screens/root_screen.dart';

/// 장바구니 아이콘 버튼 위젯
/// Badge를 통해 현재 장바구니에 담긴 아이템 개수를 표시
class CartIconButton extends StatelessWidget {
  /// 아이콘 색상 (기본값: AppColors.labelStrong)
  final Color color;

  /// 아이콘 크기
  final double size;

  /// 상품을 장바구니에 추가할 때 필요한 정보들
  final String? productId;
  final ProductItemType? productType;
  final DateTime? startDate;
  final DateTime? endDate;
  final int quantity;
  final bool isOutlined;

  const CartIconButton({
    super.key,
    this.color = AppColors.labelStrong,
    this.size = 24,
    this.productId,
    this.productType,
    this.startDate,
    this.endDate,
    this.quantity = 1,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartViewModel>(
      builder: (context, cartViewModel, child) {
        return GestureDetector(
          onTap: () async {
            // 상품 정보가 있으면 장바구니에 추가
            if (productId != null && productType != null) {
              // 숙소의 경우 날짜가 필요함
              if (productType == ProductItemType.lodging &&
                  (startDate == null || endDate == null)) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    CustomSnackBar(
                      message: '체크인/체크아웃 날짜를 먼저 선택해주세요.',
                      icon: Icons.calendar_today,
                      textColor: AppColors.statusError,
                    ),
                  );
                }
                return;
              }

              try {
                await cartViewModel.addToCart(
                  productId!,
                  productType!,
                  quantity: quantity,
                  startDate: startDate,
                  endDate: endDate,
                );

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    CustomSnackBar(
                      message: '상품이 장바구니에 담겼습니다.',
                      icon: Icons.shopping_cart_outlined,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    CustomSnackBar(
                      message: '장바구니 담기에 실패했습니다.',
                      icon: Icons.error_outline,
                    ),
                  );
                }
              }
            } else {
              // 상품 정보가 없으면 장바구니 화면으로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RootScreen(
                    selectedIndex: 2,
                  ),
                ),
              );
            }
          },
          child: Stack(
            children: [
              // 장바구니 아이콘
              Container(
                padding: isOutlined ? const EdgeInsets.all(8) : null,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: isOutlined
                      ? Border.all(
                          color: AppColors.line,
                          width: 1,
                        )
                      : null,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: size,
                ),
              ),
              // 장바구니 개수 표시
              if (cartViewModel.cartItemCount > 0)
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
                      cartViewModel.cartItemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
