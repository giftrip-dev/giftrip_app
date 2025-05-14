import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int _selectedIndex = 2; // 기본값으로 '체험단' 선택 (인덱스 2)

  // 각 카테고리별 서브카테고리 목록
  final Map<int, List<String>> _subCategories = {
    0: [
      '음식체험',
      '공예체험',
      '놀이체험',
      '공간체험',
      '문화예술체험',
      '축제체험',
      '생태체험',
      '뷰티체험',
      '웰빙체험',
      '뷰티체험',
      '웰빙체험'
    ],
    1: [
      '여행상품',
      '특산품',
      '로컬상품',
      '기념품',
      '식품',
      '건강식품',
      '생활용품,문구',
      '주방용품',
      '가구,가전용품',
      '의류,뷰티용품',
      '기타',
    ],
    2: [
      '호텔',
      '펜션',
      '독채',
      '모텔',
      '리조트',
      '민박',
      '캠핑/글램핑',
      '게스트하우스',
    ],
    3: [
      '인플루언서',
      '일반',
      '공동구매',
    ],
  };

  // 탭 타이틀 리스트
  final List<String> _tabTitles = ['체험', '상품', '숙박', '체험단'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            Text('카테고리', style: title_M.copyWith(color: AppColors.labelStrong)),
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 56,
      ),
      body: Row(
        children: [
          // 왼쪽 카테고리 탭 메뉴
          Container(
            width: 100,
            color: AppColors.backgroundNatural,
            child: Column(
              children: List.generate(_tabTitles.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: _buildCategoryTab(
                      _tabTitles[index], _selectedIndex == index),
                );
              }),
            ),
          ),
          // 오른쪽 서브 카테고리 메뉴
          Expanded(
            child: ListView(
              children: _subCategories[_selectedIndex]!
                  .map((item) => _buildSubCategoryItem(item))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String title, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      width: 100,
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.grey[100],
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: isSelected
            ? subtitle_M.copyWith(color: AppColors.labelStrong)
            : subtitle_M.copyWith(color: AppColors.labelAlternative),
      ),
    );
  }

  Widget _buildSubCategoryItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Text(
        title,
        style: body_M.copyWith(color: AppColors.label),
      ),
    );
  }
}
