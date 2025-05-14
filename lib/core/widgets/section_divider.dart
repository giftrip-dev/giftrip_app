import 'package:flutter/widgets.dart';
import 'package:myong/core/constants/app_colors.dart';

/// 높이 8인 디바이더
class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: double.infinity,
      color: AppColors.backgroundAlternative,
    );
  }
}
