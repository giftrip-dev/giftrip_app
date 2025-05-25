import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// 공통 수량 조절 위젯
class QuantityInput extends StatelessWidget {
  final int quantity;
  final ValueChanged<int>? onChanged;
  final int minQuantity;
  final int? maxQuantity;
  final double? width;
  final double height;

  const QuantityInput({
    super.key,
    required this.quantity,
    this.onChanged,
    this.minQuantity = 1,
    this.maxQuantity,
    this.width,
    this.height = 32,
  });

  @override
  Widget build(BuildContext context) {
    final canDecrease = quantity > minQuantity;
    final canIncrease = maxQuantity == null || quantity < maxQuantity!;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.gray400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 마이너스 버튼
          _QuantityButton(
            icon: LucideIcons.minus,
            enabled: canDecrease,
            onTap: canDecrease ? () => onChanged?.call(quantity - 1) : null,
          ),

          // 수량 표시
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                quantity.toString(),
                style: title_S,
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // 플러스 버튼
          _QuantityButton(
            icon: LucideIcons.plus,
            enabled: canIncrease,
            onTap: canIncrease ? () => onChanged?.call(quantity + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  const _QuantityButton({
    required this.icon,
    required this.enabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 20,
          color: enabled ? AppColors.label : AppColors.labelAlternative,
        ),
      ),
    );
  }
}
