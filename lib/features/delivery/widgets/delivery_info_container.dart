import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DeliveryInfoContainer extends StatelessWidget {
  final String title;
  final List<DeliveryInfoItem> items;
  final VoidCallback? onTextTap;
  final CTAButton? bottomButton;
  final String tapText;

  const DeliveryInfoContainer({
    super.key,
    required this.title,
    required this.items,
    this.onTextTap,
    this.bottomButton,
    this.tapText = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: subtitle_M,
          ),
          ...items.map((item) => Column(
                children: [
                  const SizedBox(height: 24),
                  _buildInfoRow(item.label, item.value),
                ],
              )),
          if (onTextTap != null)
            Column(
              children: [
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: onTextTap,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tapText,
                          style: subtitle_S,
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          LucideIcons.chevronRight,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          else if (bottomButton != null)
            Column(
              children: [
                const SizedBox(height: 32),
                bottomButton!,
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: subtitle_S),
        Text(value, style: body_S),
      ],
    );
  }
}

class DeliveryInfoItem {
  final String label;
  final String value;

  const DeliveryInfoItem({
    required this.label,
    required this.value,
  });
}
