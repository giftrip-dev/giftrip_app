import 'package:flutter/widgets.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'dart:math';

/// 상품 뱃지 위젯
class ItemBadge extends StatelessWidget {
  static final Map<String, Color> _tagColors = {};
  static final List<Color> _availableColors = [
    AppColors.statusClear,
    AppColors.statusWarning,
    AppColors.primarySoft,
    AppColors.component,
  ];
  static int? _lastColorIndex;
  static final Random _random = Random();

  final String tag;
  final Color? backgroundColor;

  const ItemBadge({
    super.key,
    required this.tag,
    this.backgroundColor,
  });

  /// 태그별 고정 색상 가져오기
  static Color _getTagColor(String tag) {
    if (!_tagColors.containsKey(tag)) {
      // 마지막 색상 인덱스와 다른 인덱스만 후보로 둠
      List<int> candidateIndexes =
          List.generate(_availableColors.length, (i) => i);
      if (_lastColorIndex != null && _availableColors.length > 1) {
        candidateIndexes.remove(_lastColorIndex);
      }
      int selectedIndex =
          candidateIndexes[_random.nextInt(candidateIndexes.length)];
      _tagColors[tag] = _availableColors[selectedIndex];
      _lastColorIndex = selectedIndex;
    }
    return _tagColors[tag]!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? _getTagColor(tag),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        tag,
        style: subtitle_XS.copyWith(color: AppColors.white),
      ),
    );
  }
}

/// 복수 배지를 표시하는 위젯
class ItemBadges extends StatelessWidget {
  final List<String> tags;
  final Color? backgroundColor;
  final double spacing;

  const ItemBadges({
    super.key,
    required this.tags,
    this.backgroundColor,
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: spacing,
      children: tags
          .map((tag) => ItemBadge(
                tag: tag,
                backgroundColor: backgroundColor,
              ))
          .toList(),
    );
  }
}
