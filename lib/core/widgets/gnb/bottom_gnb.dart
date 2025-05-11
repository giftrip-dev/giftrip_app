import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BottomGnb extends StatelessWidget {
  const BottomGnb({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent, // 터치 효과 제거
        highlightColor: Colors.transparent, // 길게 눌렀을 때 효과 제거
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        enableFeedback: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              LucideIcons.home,
              size: 24,
            ),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              LucideIcons.coffee,
              size: 24,
            ),
            label: 'community',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.labelStrong,
              ),
              child: Icon(
                LucideIcons.plus,
                color: AppColors.white,
                size: 24,
              ),
            ),
            label: 'write',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              LucideIcons.search,
              size: 24,
            ),
            label: 'search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              LucideIcons.user,
              size: 24,
            ),
            label: 'my',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onTap,
        selectedItemColor: AppColors.labelStrong,
        unselectedItemColor: AppColors.componentNatural,
        showUnselectedLabels: false,
        showSelectedLabels: false,
      ),
    );
  }
}
