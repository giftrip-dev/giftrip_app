import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/utils/formatter.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/features/shopping/models/shopping_model.dart';
import 'package:giftrip/features/shopping/view_models/shopping_view_model.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
  // 수량 선택 관련 변수
  int _quantity = 1;

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
                '구매하기',
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

          // 상품 정보 요약
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상품 이미지
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  shopping.thumbnailUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              // 상품 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shopping.title,
                      style: title_S,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '제조사: ${shopping.manufacturer}',
                      style: body_S.copyWith(color: AppColors.labelAlternative),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${formatPrice(shopping.finalPrice)}원',
                      style: title_S.copyWith(color: AppColors.labelStrong),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 수량 선택
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('수량', style: body_L),
              Row(
                children: [
                  // 수량 감소 버튼
                  _buildQuantityButton(
                    icon: LucideIcons.minus,
                    onTap: () {
                      if (_quantity > 1) {
                        setState(() {
                          _quantity--;
                        });
                      }
                    },
                    isEnabled: _quantity > 1,
                  ),

                  // 수량 표시
                  Container(
                    width: 40,
                    alignment: Alignment.center,
                    child: Text(
                      '$_quantity',
                      style: title_S,
                    ),
                  ),

                  // 수량 증가 버튼
                  _buildQuantityButton(
                    icon: LucideIcons.plus,
                    onTap: () {
                      setState(() {
                        _quantity++;
                      });
                    },
                    isEnabled: true,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 총 금액
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('총 금액', style: title_S),
              Text(
                '${formatPrice(shopping.finalPrice * _quantity)}원',
                style: title_L.copyWith(color: AppColors.labelStrong),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 구매 버튼
          CTAButton(
            text: '구매하기',
            onPressed: () {
              // 구매 처리 로직
              _processPurchase(shopping);
            },
            isEnabled: true,
          ),
        ],
      ),
    );
  }

  // 수량 조절 버튼 위젯
  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isEnabled,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(
            color: isEnabled ? AppColors.line : AppColors.line.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isEnabled ? AppColors.label : AppColors.labelAssistive,
        ),
      ),
    );
  }

  // 구매 처리 로직
  void _processPurchase(ShoppingModel shopping) {
    // 여기에 구매 처리 로직 추가
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${shopping.title} $_quantity개 구매가 완료되었습니다.'),
        duration: const Duration(seconds: 2),
      ),
    );

    // 바텀시트 닫기
    Navigator.of(context).pop();
  }
}
