import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/features/experience/models/experience_category.dart';

class ExperienceCategoryBar extends StatefulWidget {
  final ExperienceCategory? selectedCategory;
  final Function(ExperienceCategory?) onCategoryChanged;

  const ExperienceCategoryBar({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  State<ExperienceCategoryBar> createState() => _ExperienceCategoryBarState();
}

class _ExperienceCategoryBarState extends State<ExperienceCategoryBar> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _chipKeys = List.generate(
    ExperienceCategory.values.length + 1, // +1 for '전체'
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
  void didUpdateWidget(ExperienceCategoryBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCategory != oldWidget.selectedCategory) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedCategory();
      });
    }
  }

  void _scrollToSelectedCategory() {
    int selectedIndex = 0;
    if (widget.selectedCategory != null) {
      selectedIndex =
          ExperienceCategory.values.indexOf(widget.selectedCategory!) + 1;
    }
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
            // 전체 카테고리
            _CategoryChip(
              key: _chipKeys[0],
              label: '전체',
              isSelected: widget.selectedCategory == null,
              onTap: () => widget.onCategoryChanged(null),
            ),
            const SizedBox(width: 28),
            // 나머지 카테고리들
            ...ExperienceCategory.values.asMap().entries.map((entry) {
              final idx = entry.key;
              final category = entry.value;
              return Padding(
                padding: const EdgeInsets.only(right: 32),
                child: _CategoryChip(
                  key: _chipKeys[idx + 1],
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
