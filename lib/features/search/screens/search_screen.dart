import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/services/storage_service.dart';
import 'package:giftrip/core/widgets/app_bar/search_app_bar.dart';
import 'package:giftrip/core/widgets/loading/circular_progress_indicator.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giftrip/features/search/widgets/search_category_bar.dart';
import 'package:giftrip/core/constants/item_type.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final GlobalStorage _storage = GlobalStorage();
  List<String> _recentSearches = [];
  bool _isSearched = false;
  ProductItemType? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    final searches = await _storage.getRecentSearch();
    setState(() {
      _recentSearches = searches ?? [];
    });
  }

  Future<void> _onSearch(String value) async {
    if (value.trim().isEmpty) return;
    await _storage.setRecentSearch(value.trim());
    _controller.clear();
    await _loadRecentSearches();
    setState(() {
      _isSearched = true;
    });
  }

  Future<void> _deleteSearch(String search) async {
    await _storage.deleteRecentSearch(search);
    await _loadRecentSearches();
  }

  Future<void> _deleteAllSearches() async {
    await _storage.write("recentSearches", "[]");
    await _loadRecentSearches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchAppBar(title: '검색'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 검색창
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E6EB)),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.search, color: AppColors.component),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: '상품명',
                        hintStyle:
                            body_M.copyWith(color: AppColors.labelAlternative),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isCollapsed: false,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 12),
                      ),
                      onSubmitted: _onSearch,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _isSearched
                ? SearchCategoryBar(
                    selectedCategory: _selectedCategory,
                    onCategoryChanged: (cat) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    totalCount: 0,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('최근 검색',
                          style: subtitle_M.copyWith(
                              color: AppColors.labelStrong)),
                      if (_recentSearches.isNotEmpty)
                        GestureDetector(
                          onTap: _deleteAllSearches,
                          child: Text('전체 삭제',
                              style: body_S.copyWith(
                                  color: const Color(0xFF909090))),
                        ),
                    ],
                  ),
            const SizedBox(height: 16),
            if (!_isSearched && _recentSearches.isEmpty)
              const Text('최근 검색어가 없습니다.', style: TextStyle(color: Colors.grey)),
            if (!_isSearched && _recentSearches.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _recentSearches.map((search) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundAlternative,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(search,
                              style: title_XS.copyWith(
                                  color: AppColors.labelStrong)),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => _deleteSearch(search),
                            child: Icon(LucideIcons.x,
                                size: 16, color: AppColors.componentNatural),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
