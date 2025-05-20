import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';

class GuestWidget extends StatelessWidget {
  final int adultCount;
  final int childCount;
  final ValueChanged<int> onAdultChanged;
  final ValueChanged<int> onChildChanged;

  const GuestWidget({
    super.key,
    required this.adultCount,
    required this.childCount,
    required this.onAdultChanged,
    required this.onChildChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(
            label: '성인',
            count: adultCount,
            onChanged: onAdultChanged,
            min: 1,
          ),
          const SizedBox(height: 24),
          _buildRow(
            label: '아동',
            count: childCount,
            onChanged: onChildChanged,
            min: 0,
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required String label,
    required int count,
    required ValueChanged<int> onChanged,
    required int min,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$label ${count}명', style: body_M),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(12),
            color: AppColors.background,
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove,
                    color: count > min ? AppColors.label : AppColors.line),
                onPressed: count > min ? () => onChanged(count - 1) : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('$count', style: title_M),
              ),
              IconButton(
                icon: Icon(Icons.add, color: AppColors.label),
                onPressed: () => onChanged(count + 1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
