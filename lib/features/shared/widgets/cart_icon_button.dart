import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:myong/features/cart/view_models/cart_view_model.dart';

/// 장바구니 아이콘 버튼 위젯
/// Badge를 통해 현재 장바구니에 담긴 아이템 개수를 표시
class CartIconButton extends StatefulWidget {
  /// 클릭 시 실행할 콜백 함수 (기본값: 장바구니 페이지로 이동)
  final VoidCallback? onPressed;

  /// 아이콘 색상 (기본값: null - 현재 테마에 따름)
  final Color? color;

  /// 뱃지 배경색 (기본값: AppColors.primary)
  final Color badgeColor;

  /// 아이콘 크기
  final double size;

  /// 아이콘 패딩 적용 방식 (일반 IconButton vs GestureDetector)
  final bool useIconButton;

  const CartIconButton({
    this.onPressed,
    this.color,
    this.badgeColor = AppColors.primarySoft,
    this.size = 24.0,
    this.useIconButton = false,
    super.key,
  });

  @override
  State<CartIconButton> createState() => _CartIconButtonState();
}

class _CartIconButtonState extends State<CartIconButton> {
  int _itemCount = 0; // 로컬 상태로 아이템 개수 관리

  @override
  void initState() {
    super.initState();
    // 위젯이 처음 생성될 때 장바구니 정보 조회 시도
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCartItems();
    });
  }

  /// 장바구니 정보 조회 (Provider 존재 여부 확인)
  void _fetchCartItems() {
    try {
      // Provider가 존재하는지 확인
      if (mounted && _isCartViewModelAvailable()) {
        final cartVM = Provider.of<CartViewModel>(context, listen: false);
        if (!cartVM.isLoading) {
          cartVM.fetchCartItems();
        }
      }
    } catch (e) {
      // Provider를 찾을 수 없는 경우 무시
      debugPrint('CartViewModel이 Provider 트리에 존재하지 않습니다: $e');
    }
  }

  /// CartViewModel Provider가 사용 가능한지 확인
  bool _isCartViewModelAvailable() {
    try {
      Provider.of<CartViewModel>(context, listen: false);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// 장바구니 페이지로 이동
  void _navigateToCart() {
    Navigator.pushNamed(context, '/cart');
  }

  @override
  Widget build(BuildContext context) {
    // Provider 존재 여부에 따라 다른 위젯 반환
    if (_isCartViewModelAvailable()) {
      return _buildWithProvider();
    } else {
      return _buildWithoutProvider();
    }
  }

  /// Provider가 있을 때 Consumer 사용
  Widget _buildWithProvider() {
    return Consumer<CartViewModel>(
      builder: (context, cartVM, child) {
        return _buildBadge(cartVM.itemCount);
      },
    );
  }

  /// Provider가 없을 때 로컬 상태 사용
  Widget _buildWithoutProvider() {
    return _buildBadge(_itemCount);
  }

  /// 뱃지와 아이콘 생성
  Widget _buildBadge(int itemCount) {
    final cartButton = widget.useIconButton
        ? IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              size: widget.size,
            ),
            color: widget.color,
            onPressed: widget.onPressed ?? _navigateToCart,
          )
        : GestureDetector(
            onTap: widget.onPressed ?? _navigateToCart,
            behavior: HitTestBehavior.opaque,
            child: Icon(
              Icons.shopping_cart_outlined,
              size: widget.size,
              color: widget.color ?? Colors.black,
            ),
          );

    return Badge(
      backgroundColor: widget.badgeColor,
      isLabelVisible: itemCount > 0,
      label: Text(
        '$itemCount',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: cartButton,
    );
  }
}
