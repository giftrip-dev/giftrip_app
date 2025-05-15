import 'package:flutter/widgets.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/features/home/models/product_model.dart';

/// 상품 뱃지 위젯
class ItemBadge extends StatelessWidget {
  final ProductTagType type;

  const ItemBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return _buildSingleBadge(type);
  }

  /// 단일 배지 위젯
  static Widget _buildSingleBadge(ProductTagType type) {
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

/// 복수 배지를 표시하는 위젯
class ItemBadges extends StatelessWidget {
  final List<ProductTagType> badges;
  final double spacing;

  const ItemBadges({
    super.key,
    required this.badges,
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: spacing,
      children:
          badges.map((badge) => ItemBadge._buildSingleBadge(badge)).toList(),
    );
  }
}

extension ProductTagTypeProps on ProductTagType {
  String get label {
    switch (this) {
      case ProductTagType.newArrival:
        return 'NEW';
      case ProductTagType.bestSeller:
        return 'BEST';
      case ProductTagType.almostSoldOut:
        return '품절임박';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case ProductTagType.newArrival:
        return AppColors.statusAlarm;
      case ProductTagType.bestSeller:
        return AppColors.primarySoft;
      case ProductTagType.almostSoldOut:
        return AppColors.statusError;
    }
  }
}
