import 'package:flutter/foundation.dart';
import 'package:myong/core/utils/logger.dart';
import 'package:myong/core/utils/page_meta.dart';
import 'package:myong/features/experience/models/experience_category.dart';
import 'package:myong/features/experience/models/experience_model.dart';
import 'package:myong/features/experience/repositories/experience_repo.dart';

/// 체험 상품 뷰모델
class ExperienceViewModel extends ChangeNotifier {
  final ExperienceRepo _repo = ExperienceRepo();

  // 상태 저장
  List<ExperienceModel> _experienceList = [];
  PageMeta? _meta;
  bool _isLoading = false;
  bool _hasError = false;
  ExperienceCategory? _selectedCategory;

  // 외부 접근용 Getter
  List<ExperienceModel> get experienceList => _experienceList;
  PageMeta? get meta => _meta;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  ExperienceCategory? get selectedCategory => _selectedCategory;

  /// 다음 페이지 번호 계산
  int? get nextPage {
    if (_meta == null) return null;
    return _meta!.currentPage < _meta!.totalPages
        ? _meta!.currentPage + 1
        : null;
  }

  /// 카테고리 변경
  void changeCategory(ExperienceCategory? category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    fetchExperienceList(refresh: true);
  }

  /// 체험 상품 목록 조회
  Future<void> fetchExperienceList({bool refresh = false}) async {
    // 이미 로딩 중이거나, 첫 로드/새로고침이 아닌데 다음 페이지가 없는 경우 리턴
    if (_isLoading ||
        (!refresh && _experienceList.isNotEmpty && nextPage == null)) {
      return;
    }

    try {
      _isLoading = true;
      _hasError = false;
      notifyListeners();

      // 새로고침이거나 첫 로드인 경우 페이지 1부터 시작
      final page = refresh || _experienceList.isEmpty ? 1 : (nextPage ?? 1);

      final response = await _repo.getExperienceList(
        category: _selectedCategory,
        page: page,
      );

      if (refresh || _experienceList.isEmpty) {
        _experienceList = response.items;
      } else {
        _experienceList = [..._experienceList, ...response.items];
      }
      _meta = response.meta;
    } catch (e) {
      _hasError = true;
      logger.e('체험 상품 목록 조회 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
