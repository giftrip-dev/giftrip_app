import 'package:flutter/widgets.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/features/home/models/product_model.dart';

/// 상품 뱃지 위젯
class ItemBadge extends StatelessWidget {
  final ItemBadgeType type;

  const ItemBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
        color: type.backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type.label,
        style: subtitle_XS.copyWith(color: AppColors.white),
      ),
    );
  }
}

extension ItemBadgeTypeProps on ItemBadgeType {
  String get label {
    switch (this) {
      case ItemBadgeType.newArrival:
        return 'NEW';
      case ItemBadgeType.bestSeller:
        return 'BEST';
      case ItemBadgeType.almostSoldOut:
        return '품절임박';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case ItemBadgeType.newArrival:
        return AppColors.statusAlarm;
      case ItemBadgeType.bestSeller:
        return AppColors.primarySoft;
      case ItemBadgeType.almostSoldOut:
        return AppColors.statusError;
    }
  }
}
