import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/enum/community_enum.dart';
import 'package:giftrip/features/community/widgets/category_bottom_sheet.dart';
import 'package:giftrip/features/root/screens/root_screen.dart';
import 'package:giftrip/core/widgets/modal/two_button_modal.dart';

class WriteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BeautyCategory selectedCategory;
  final Function(BeautyCategory) onCategorySelected;
  final VoidCallback? onSubmit;
  final bool isSubmitting; // 로딩 상태 추가
  final bool hasContent; // 새로운 속성 추가

  const WriteAppBar({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onSubmit,
    required this.isSubmitting,
    required this.hasContent, // 새로운 속성 추가
  });

  void _showCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => WriteCategoryBottomSheet(
        selectedCategory: selectedCategory,
        onCategorySelected: onCategorySelected,
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: GestureDetector(
        onTap: () => _showCategoryBottomSheet(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              BeautyCategory.toKoreanString(selectedCategory),
              style: title_M,
            ),
            const SizedBox(width: 4),
            Icon(
              LucideIcons.chevronDown,
              size: 18,
              color: AppColors.componentNatural,
            ),
          ],
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(16),
        child: GestureDetector(
          onTap: () {
            if (hasContent) {
              showDialog(
                context: context,
                builder: (context) => TwoButtonModal(
                  title: '작성중인 게시글을 삭제하시나요?',
                  desc: '삭제된 게시글은 다시 불러올 수 없습니다.',
                  confirmText: '확인',
                  onConfirm: () {
                    Navigator.pop(context); // 모달 닫기
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const RootScreen(selectedIndex: 0),
                        ),
                        (route) => false,
                      );
                    }
                  },
                ),
              );
            } else {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RootScreen(selectedIndex: 0),
                  ),
                  (route) => false,
                );
              }
            }
          },
          child: const Icon(
            LucideIcons.chevronLeft,
            size: 24,
            color: Colors.black,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: isSubmitting
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
              : TextButton(
                  onPressed: onSubmit,
                  child: Text(
                    "완료",
                    style: title_M.copyWith(color: AppColors.primary),
                  ),
                ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
