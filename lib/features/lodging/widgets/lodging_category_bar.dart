import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/features/lodging/models/lodging_category.dart';

class LodgingCategoryBar extends StatefulWidget {
  final LodgingCategory? selectedCategory;
  final Function(LodgingCategory?) onCategoryChanged;

  const LodgingCategoryBar({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  State<LodgingCategoryBar> createState() => _LodgingCategoryBarState();
}

class _LodgingCategoryBarState extends State<LodgingCategoryBar> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _chipKeys = List.generate(
    LodgingCategory.values.length,
    (index) => GlobalKey(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedCategory();
    });
  }

  @override
  void didUpdateWidget(LodgingCategoryBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCategory != oldWidget.selectedCategory) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedCategory();
      });
    }
  }

  void _scrollToSelectedCategory() {
    if (widget.selectedCategory == null) return;

    int selectedIndex =
        LodgingCategory.values.indexOf(widget.selectedCategory!);
    final key = _chipKeys[selectedIndex];
    final context = key.currentContext;
    if (context == null) return;
    final box = context.findRenderObject() as RenderBox;
    final chipPosition = box.localToGlobal(Offset.zero,
        ancestor: this.context.findRenderObject());
    final chipWidth = box.size.width;
    final screenWidth = MediaQuery.of(context).size.width;
    final scrollOffset = _scrollController.offset +
        chipPosition.dx +
        chipWidth / 2 -
        screenWidth / 2;
    _scrollController.animateTo(
      scrollOffset.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            ...LodgingCategory.values.asMap().entries.map((entry) {
              final idx = entry.key;
              final category = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                  right: idx < LodgingCategory.values.length - 1 ? 32 : 0,
                ),
                child: _CategoryChip(
                  key: _chipKeys[idx],
                  label: category.label,
                  isSelected: widget.selectedCategory == category,
                  onTap: () => widget.onCategoryChanged(category),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// 카테고리 칩 위젯
class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        decoration: BoxDecoration(
          border: isSelected
              ? Border(
                  bottom: BorderSide(
                    color: AppColors.labelStrong,
                    width: 1.5,
                  ),
                )
              : null,
        ),
        child: Text(
          label,
          style: title_S.copyWith(
            color:
                isSelected ? AppColors.labelStrong : AppColors.labelAlternative,
          ),
        ),
      ),
    );
  }
}
