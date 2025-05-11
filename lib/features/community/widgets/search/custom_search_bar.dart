import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/services/storage_service.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final List<String> recentSearches;
  final Function(String) onSearch;
  final Function(String) onRemoveSearch;
  final Function() onClearSearch;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.recentSearches,
    required this.onSearch,
    required this.onRemoveSearch,
    required this.onClearSearch,
  });

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  bool _showRecentSearches = true; // 최근 검색어 표시 여부

  void _onChipTap(String search) {
    setState(() {
      widget.controller.text = search;
      _showRecentSearches = false; // 검색어 선택 시 최근 검색어 숨기기
    });
    widget.onSearch(search);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: widget.controller,
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                widget.onSearch(value);
                _showRecentSearches = false; // 검색어 제출 시 최근 검색어 숨기기
                if (!widget.recentSearches.contains(value)) {
                  setState(() {
                    widget.recentSearches.insert(0, value);
                  });
                  GlobalStorage().setRecentSearch(value);
                }
              }
            },
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.line),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.line),
              ),
              hintText: '검색어를 입력해주세요',
              hintStyle: body_2.copyWith(color: AppColors.labelAlternative),
              suffixIcon: GestureDetector(
                onTap: () {
                  if (_showRecentSearches) {
                    if (widget.controller.text.isNotEmpty) {
                      widget.onSearch(widget.controller.text);
                      _showRecentSearches = false; // 검색어 제출 시 최근 검색어 숨기기
                      if (!widget.recentSearches
                          .contains(widget.controller.text)) {
                        setState(() {
                          widget.recentSearches
                              .insert(0, widget.controller.text);
                        });
                        GlobalStorage().setRecentSearch(widget.controller.text);
                      }
                    }
                  } else {
                    // xCircle 클릭 시 검색어 지우기
                    setState(() {
                      widget.controller.clear();
                      _showRecentSearches = true; // 최근 검색어 다시 표시
                    });
                    widget.onClearSearch();
                  }
                },
                child: Icon(
                  _showRecentSearches
                      ? LucideIcons.search
                      : LucideIcons.xCircle,
                  color: AppColors.componentNatural,
                  size: 20,
                ),
              ),
            ),
          ),
          // 최근 검색어 표시 여부에 따라 조건부 렌더링
          if (_showRecentSearches)
            Column(children: [
              const SizedBox(height: 16),
              Text(
                '최근 검색어',
                style: title_M,
              ),
              const SizedBox(height: 10),
            ]),
          if (_showRecentSearches) // 최근 검색어 표시 여부에 따라 조건부 렌더링
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // 가로 스크롤 가능
              child: Row(
                children: widget.recentSearches.map((search) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0), // 간격 추가
                    child: GestureDetector(
                      onTap: () => _onChipTap(search),
                      child: Chip(
                        backgroundColor: AppColors.backgroundAlternative,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: BorderSide(color: AppColors.line),
                        ),
                        label: Text(search, style: title_XS),
                        deleteIcon: const Icon(LucideIcons.x),
                        onDeleted: () {
                          setState(() {
                            widget.recentSearches.remove(search);
                          });
                          widget.onRemoveSearch(search);
                          GlobalStorage().deleteRecentSearch(search);
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
