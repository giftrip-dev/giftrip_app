import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/features/category/models/category.dart';
import 'package:giftrip/features/category/widgets/category_tab.dart';
import 'package:giftrip/features/category/widgets/sub_category_item.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int _selectedIndex = 0;
  late final List<CategoryData> _categoryData;

  @override
  void initState() {
    super.initState();
    _categoryData = CategoryManager.getCategoryData();
  }

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
              children: List.generate(_categoryData.length, (index) {
                return CategoryTab(
                  title: _categoryData[index].mainCategory.label,
                  isSelected: _selectedIndex == index,
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                );
              }),
            ),
          ),
          // 오른쪽 서브 카테고리 메뉴
          Expanded(
            child: ListView(
              children: _categoryData[_selectedIndex]
                  .subCategories
                  .map((item) => SubCategoryItem(
                        title: item,
                        categoryIndex: _selectedIndex,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
