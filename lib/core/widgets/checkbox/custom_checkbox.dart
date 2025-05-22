import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;
  final String label;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border.all(
                color: value ? AppColors.primaryStrong : AppColors.line,
                width: 1,
              ),
              color: value ? AppColors.primaryStrong : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: value
                ? const Icon(
                    LucideIcons.check,
                    size: 16,
                    color: Colors.white,
                    weight: 3,
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: body_S,
          ),
        ],
      ),
    );
  }
}
