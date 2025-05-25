import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/core/utils/formatter.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/core/widgets/snack_bar/custom_snack_bar.dart';
import 'package:giftrip/features/cart/view_models/cart_view_model.dart';
import 'package:giftrip/features/payment/screens/payment_screen.dart';
import 'package:giftrip/features/payment/view_models/payment_view_model.dart';
import 'package:giftrip/features/shared/widgets/quantity_selector.dart';
import 'package:giftrip/features/shopping/models/shopping_model.dart';
import 'package:giftrip/features/shopping/view_models/shopping_view_model.dart';
import 'package:giftrip/features/shopping/widgets/shopping_option_selector.dart';
import 'package:provider/provider.dart';

/// 쇼핑 구매 바텀시트
class ShoppingPurchaseBottomSheet extends StatefulWidget {
  final VoidCallback? onClose;

  const ShoppingPurchaseBottomSheet({
    super.key,
    this.onClose,
  });

  @override
  State<ShoppingPurchaseBottomSheet> createState() =>
      _ShoppingPurchaseBottomSheetState();

  /// 바텀시트를 표시하는 정적 메서드
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 키보드가 올라왔을 때 바텀시트를 밀어올리도록
      backgroundColor: Colors.transparent,
      builder: (context) => ShoppingPurchaseBottomSheet(
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }
}

class _ShoppingPurchaseBottomSheetState
    extends State<ShoppingPurchaseBottomSheet> {
  // 선택된 옵션과 수량을 관리하는 Map
  final Map<ShoppingOption, int> _selectedOptions = {};

  // 총 금액 계산
  int get _totalPrice {
    return _selectedOptions.entries.fold(
      0,
      (sum, entry) => sum + (entry.key.price * entry.value),
    );
  }

  int get _shippingFee {
    return _totalPrice < 30000 ? 2500 : 0;
  }

  int get _finalPrice {
    return _totalPrice + _shippingFee;
  }

  // 옵션 선택 처리
  void _handleOptionSelected(ShoppingOption option) {
    setState(() {
      if (!_selectedOptions.containsKey(option)) {
        _selectedOptions[option] = 1;
      }
    });
  }

  // 옵션 수량 변경 처리
  void _handleQuantityChanged(ShoppingOption option, int quantity) {
    setState(() {
      _selectedOptions[option] = quantity;
    });
  }

  // 장바구니 추가
  Future<void> _handleAddToCart(ShoppingModel shopping) async {
    final cartViewModel = context.read<CartViewModel>();

    try {
      // 선택된 옵션들을 하나의 상품으로 처리
      await cartViewModel.addToCart(
        shopping.id,
        ProductItemType.product,
        quantity:
            _selectedOptions.values.fold(0, (sum, quantity) => sum + quantity),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message: '상품이 장바구니에 담겼습니다.',
            icon: Icons.shopping_cart_outlined,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message: '장바구니 담기에 실패했습니다.',
            icon: Icons.error_outline,
            textColor: AppColors.statusError,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 쇼핑 상품 정보 가져오기
    final viewModel = context.watch<ShoppingViewModel>();
    final shopping = viewModel.selectedShopping;

    if (shopping == null) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 (제목 + 닫기 버튼)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 제목
              Text(
                '상품 구매',
                style: title_L,
              ),

              // 닫기 버튼
              GestureDetector(
                onTap: () {
                  if (widget.onClose != null) {
                    widget.onClose!();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: const SizedBox(
                  width: 24,
                  height: 24,
                  child: Icon(
                    Icons.close,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 스크롤 가능한 영역
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 240, minHeight: 240),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 옵션 선택
                  ShoppingOptionSelector(
                    options: shopping.options,
                    selectedOption: null, // 여러 옵션 선택 가능하므로 null로 설정
                    onOptionSelected: _handleOptionSelected,
                  ),

                  // 선택된 옵션들과 수량 선택기
                  ..._selectedOptions.entries.map((entry) {
                    return Column(
                      children: [
                        const SizedBox(height: 12),
                        // 수량 선택기
                        QuantitySelector(
                          productName: entry.key.name,
                          price: entry.key.price,
                          quantity: entry.value,
                          onQuantityChanged: (quantity) =>
                              _handleQuantityChanged(entry.key, quantity),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          // 선택된 옵션이 있을 때만 표시
          if (_selectedOptions.isNotEmpty) ...[
            Divider(
              color: AppColors.line,
            ),

            // 총 금액
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('총 금액', style: body_S),
                Text(
                  '${formatPrice(_totalPrice)}원',
                  style: body_S.copyWith(color: AppColors.labelStrong),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 배송비
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('배송비', style: body_S),
                Text(
                  '${formatPrice(_shippingFee)}원',
                  style: body_S.copyWith(color: AppColors.labelStrong),
                ),
              ],
            ),

            Divider(
              color: AppColors.line,
            ),

            // 결제 예상 금액
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('결제 예상 금액', style: body_S),
                Text(
                  '${formatPrice(_finalPrice)}원',
                  style: subtitle_L.copyWith(color: AppColors.labelStrong),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),

          // 버튼 영역
          Row(
            children: [
              // 장바구니 버튼
              Expanded(
                flex: 120,
                child: CTAButton(
                  text: '장바구니',
                  type: CTAButtonType.outline,
                  size: CTAButtonSize.extraLarge,
                  onPressed: _selectedOptions.isNotEmpty
                      ? () => _handleAddToCart(shopping)
                      : null,
                  isEnabled: _selectedOptions.isNotEmpty,
                ),
              ),
              const SizedBox(width: 8),
              // 구매하기 버튼
              Expanded(
                flex: 200,
                child: CTAButton(
                  text: '구매하기',
                  onPressed: _selectedOptions.isNotEmpty
                      ? () => _processPurchase(shopping)
                      : null,
                  isEnabled: _selectedOptions.isNotEmpty,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 구매 처리 로직
  void _processPurchase(ShoppingModel shopping) {
    final paymentViewModel = context.read<PaymentViewModel>();

    // 선택된 옵션들을 PaymentItem으로 변환
    final paymentItems = _selectedOptions.entries.map((entry) {
      return PaymentItem(
        optionName: entry.key.name,
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: shopping.id,
        title: '${shopping.title} - ${entry.key.name}',
        thumbnailUrl: shopping.thumbnailUrl,
        price: entry.key.price,
        quantity: entry.value,
        type: ProductItemType.product,
      );
    }).toList();

    // 결제 예정 데이터 설정
    paymentViewModel.setItems(paymentItems);

    // 바텀시트 닫기
    Navigator.of(context).pop();

    // 결제 페이지로 이동
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PaymentScreen(),
      ),
    );
  }
}
