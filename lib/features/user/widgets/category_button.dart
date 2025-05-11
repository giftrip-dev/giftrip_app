import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';

class CategoryButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String? selectedImagePath;
  final String? unselectedImagePath;

  const CategoryButton({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.selectedImagePath,
    this.unselectedImagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 156,
        height: 156,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFFF7F9)
              : AppColors.componentAlternative,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected ? AppColors.primary : AppColors.componentAlternative,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              isSelected ? selectedImagePath! : unselectedImagePath!,
              width: 32,
              height: 32,
            ),
            const SizedBox(height: 8),
            Text(label,
                style: title_S.copyWith(
                  color:
                      isSelected ? AppColors.label : AppColors.labelAlternative,
                )),
          ],
        ),
      ),
    );
  }
}
