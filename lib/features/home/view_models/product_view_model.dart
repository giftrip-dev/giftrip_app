import 'package:flutter/foundation.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/home/models/product_model.dart';
import 'package:giftrip/features/home/repositories/product_repo.dart';

/// 목업용 상품 리스트 (쇼핑 상품 + 기타 상품들)
final List<ProductModel> mockProducts = () {
  // 모든 상품을 담을 리스트 생성
  List<ProductModel> allProducts = [];

  // 체험 상품들 추가
  allProducts.addAll(List.generate(
    10,
    (index) {
      final id = 'exp_${index + 1}';
      final originalPrice = 20000 + (index * 1000);
      final discountRate = (index % 4 == 0) ? ((index * 3) % 40 + 10) : 0;
      final finalPrice = discountRate > 0
          ? ((originalPrice * (100 - discountRate)) / 100).round()
          : originalPrice;

      List<ProductTagType> badges = [];
      List<String> itemTags = [];
      if (index % 3 == 0) {
        badges.add(ProductTagType.newArrival);
        itemTags.add('신상품');
      }
      if (index % 5 == 0) {
        badges.add(ProductTagType.bestSeller);
        itemTags.add('베스트');
      }
      if (index % 8 == 7) {
        badges.add(ProductTagType.almostSoldOut);
        itemTags.add('품절임박');
      }

      return ProductModel(
        id: id,
        thumbnailUrl: 'assets/png/banner.png',
        title: '체험 상품 제목 ${index + 1}',
        originalPrice: originalPrice,
        finalPrice: finalPrice,
        discountRate: discountRate,
        exposureTags: index % 2 == 0 ? ['new'] : [],
        itemTags: itemTags,
        itemType: 'experience',
        createdAt: DateTime.now().subtract(Duration(days: index)),
        updatedAt: DateTime.now().subtract(Duration(days: index - 1)),
        productType: ProductType.experience,
        badges: badges.isNotEmpty ? badges : null,
      );
    },
  ));

  // 숙소 상품들 추가
  allProducts.addAll(List.generate(
    8,
    (index) {
      final id = 'lodging_${index + 1}';
      final originalPrice = 80000 + (index * 5000);
      final discountRate = (index % 3 == 0) ? ((index * 2) % 30 + 5) : 0;
      final finalPrice = discountRate > 0
          ? ((originalPrice * (100 - discountRate)) / 100).round()
          : originalPrice;

      List<ProductTagType> badges = [];
      List<String> itemTags = [];
      if (index % 4 == 0) {
        badges.add(ProductTagType.newArrival);
        itemTags.add('신상품');
      }
      if (index % 6 == 0) {
        badges.add(ProductTagType.bestSeller);
        itemTags.add('베스트');
      }

      return ProductModel(
        id: id,
        thumbnailUrl: 'assets/png/banner.png',
        title: '숙소 상품 제목 ${index + 1}',
        originalPrice: originalPrice,
        finalPrice: finalPrice,
        discountRate: discountRate,
        exposureTags: index % 3 == 0 ? ['new'] : [],
        itemTags: itemTags,
        itemType: 'lodging',
        createdAt: DateTime.now().subtract(Duration(days: index)),
        updatedAt: DateTime.now().subtract(Duration(days: index - 1)),
        productType: ProductType.lodging,
        badges: badges.isNotEmpty ? badges : null,
      );
    },
  ));

  // 체험단 상품들 추가
  allProducts.addAll(List.generate(
    6,
    (index) {
      final id = 'tester_${index + 1}';
      final originalPrice = 25000 + (index * 3000);
      final discountRate = (index % 4 == 0) ? ((index * 2) % 25 + 10) : 0;
      final finalPrice = discountRate > 0
          ? ((originalPrice * (100 - discountRate)) / 100).round()
          : originalPrice;

      List<ProductTagType> badges = [];
      List<String> itemTags = [];
      if (index % 3 == 0) {
        badges.add(ProductTagType.newArrival);
        itemTags.add('신상품');
      }
      if (index % 5 == 0) {
        badges.add(ProductTagType.bestSeller);
        itemTags.add('베스트');
      }
      if (index % 7 == 6) {
        badges.add(ProductTagType.almostSoldOut);
        itemTags.add('품절임박');
      }

      return ProductModel(
        id: id,
        thumbnailUrl: 'assets/png/banner.png',
        title: '체험단 상품 제목 ${index + 1}',
        originalPrice: originalPrice,
        finalPrice: finalPrice,
        discountRate: discountRate,
        exposureTags: index % 2 == 1 ? ['new'] : [],
        itemTags: itemTags,
        itemType: 'experienceGroup',
        createdAt: DateTime.now().subtract(Duration(days: index)),
        updatedAt: DateTime.now().subtract(Duration(days: index - 1)),
        productType: ProductType.experienceGroup,
        badges: badges.isNotEmpty ? badges : null,
      );
    },
  ));

  // 리스트를 랜덤하게 섞기
  allProducts.shuffle();

  return allProducts;
}();

/// 섹션 구분용 enum
enum ProductSection { newArrivals, bestSellers, timeDeals, relatedProducts }

class ProductViewModel extends ChangeNotifier {
  final ProductRepo _repo = ProductRepo();

  /// 목업 데이터를 사용할지 판단하는 플래그
  /// todo: 목업 플래그 없애기
  final bool useMock = false;

  // 상태 저장
  List<ProductModel> _newList = [];
  List<ProductModel> _bestList = [];
  List<ProductModel> _timeDealList = [];
  List<ProductModel> _relatedList = [];
  PageMeta? _newMeta;
  PageMeta? _bestMeta;
  PageMeta? _timeDealMeta;
  PageMeta? _relatedMeta;
  bool _isLoading = false;

  // 외부 접근용 Getter
  List<ProductModel> get newList => _newList;
  List<ProductModel> get bestList => _bestList;
  List<ProductModel> get timeDealList => _timeDealList;
  List<ProductModel> get relatedList => _relatedList;
  PageMeta? get newMeta => _newMeta;
  PageMeta? get bestMeta => _bestMeta;
  PageMeta? get timeDealMeta => _timeDealMeta;
  PageMeta? get relatedMeta => _relatedMeta;
  bool get isLoading => _isLoading;

  /// 다음 페이지 번호 계산 (NEW)
  int? get nextNewPage {
    if (_newMeta == null) return null;
    return _newMeta!.currentPage < _newMeta!.totalPages
        ? _newMeta!.currentPage + 1
        : null;
  }

  /// 다음 페이지 번호 계산 (BEST)
  int? get nextBestPage {
    if (_bestMeta == null) return null;
    return _bestMeta!.currentPage < _bestMeta!.totalPages
        ? _bestMeta!.currentPage + 1
        : null;
  }

  /// 다음 페이지 번호 계산 (TIME DEAL)
  int? get nextTimeDealPage {
    if (_timeDealMeta == null) return null;
    return _timeDealMeta!.currentPage < _timeDealMeta!.totalPages
        ? _timeDealMeta!.currentPage + 1
        : null;
  }

  /// 다음 페이지 번호 계산 (RELATED)
  int? get nextRelatedPage {
    if (_relatedMeta == null) return null;
    return _relatedMeta!.currentPage < _relatedMeta!.totalPages
        ? _relatedMeta!.currentPage + 1
        : null;
  }

  /// 추가 데이터 여부
  bool get hasMoreNew => nextNewPage != null;
  bool get hasMoreBest => nextBestPage != null;
  bool get hasMoreTimeDeal => nextTimeDealPage != null;
  bool get hasMoreRelated => nextRelatedPage != null;

  /// 신상품 조회 (목업/실제 API 분기)
  Future<void> fetchNewProducts({int page = 1, int limit = 10}) async {
    _isLoading = true;
    notifyListeners();

    // UX 완화를 위한 지연
    await Future.delayed(Duration(milliseconds: page == 1 ? 100 : 300));

    try {
      final response = await _repo.getNewProductList(page: page, limit: limit);
      logger.d('신상품 조회 성공: ${response.items.map((e) => e.toJson())}');
      if (page == 1) {
        _newList = response.items;
      } else {
        _newList.addAll(response.items);
      }
      _newMeta = response.meta;
    } catch (e, st) {
      logger.e('신상품 조회 실패: $e\n$st');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 베스트상품 조회 (목업/실제 API 분기)
  Future<void> fetchBestProducts({int page = 1, int limit = 10}) async {
    _isLoading = true;
    notifyListeners();

    // UX 완화를 위한 지연
    await Future.delayed(Duration(milliseconds: page == 1 ? 100 : 300));

    try {
      final resp = await _repo.getBestProductList(page: page, limit: limit);
      if (page == 1) {
        _bestList = resp.items;
      } else {
        _bestList.addAll(resp.items);
      }
      _bestMeta = resp.meta;
    } catch (e, st) {
      logger.e('베스트상품 조회 실패: $e\n$st');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 타임 딜 조회
  Future<void> fetchTimeDealProducts({int page = 1, int limit = 10}) async {
    _isLoading = true;
    notifyListeners();

    // UX 완화를 위한 지연
    await Future.delayed(Duration(milliseconds: page == 1 ? 100 : 300));

    try {
      final resp = await _repo.getTimeDealProductList(page: page, limit: limit);
      if (page == 1) {
        _timeDealList = resp.items;
      } else {
        _timeDealList.addAll(resp.items);
      }
      _timeDealMeta = resp.meta;
    } catch (e, st) {
      logger.e('타임 딜 조회 실패: $e\n$st');
    } finally {
      _isLoading = false;
    }
  }

  /// 관련 상품 조회
  Future<void> fetchRelatedProducts({
    required ProductType productType,
    String? productId,
    int page = 1,
    int limit = 10,
  }) async {
    _isLoading = true;
    notifyListeners();

    // 지연
    await Future.delayed(Duration(milliseconds: page == 1 ? 200 : 500));

    try {
      final resp = await _repo.getRelatedProducts(
        productType: productType,
        productId: productId,
        page: page,
        limit: limit,
      );
      if (page == 1) {
        _relatedList = resp.items;
      } else {
        _relatedList.addAll(resp.items);
      }
      _relatedMeta = resp.meta;
    } catch (e, st) {
      logger.e('관련 상품 조회 실패: $e\n$st');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// NEXT/PREV helpers
  Future<void> nextPageNew() async {
    final next = nextNewPage;
    if (next != null) await fetchNewProducts(page: next);
  }

  Future<void> prevPageNew() async {
    if (_newMeta != null && _newMeta!.currentPage > 1) {
      await fetchNewProducts(page: _newMeta!.currentPage - 1);
    }
  }

  Future<void> nextPageBest() async {
    final next = nextBestPage;
    if (next != null) await fetchBestProducts(page: next);
  }

  Future<void> prevPageBest() async {
    if (_bestMeta != null && _bestMeta!.currentPage > 1) {
      await fetchBestProducts(page: _bestMeta!.currentPage - 1);
    }
  }

  Future<void> nextPageTimeDeal() async {
    final next = nextTimeDealPage;
    if (next != null) await fetchTimeDealProducts(page: next);
  }

  Future<void> prevPageTimeDeal() async {
    if (_timeDealMeta != null && _timeDealMeta!.currentPage > 1) {
      await fetchTimeDealProducts(page: _timeDealMeta!.currentPage - 1);
    }
  }

  /// NEXT/PREV helpers (RELATED)
  Future<void> nextPageRelated(
      {required ProductType productType, String? productId}) async {
    final next = nextRelatedPage;
    if (next != null) {
      await fetchRelatedProducts(
        productType: productType,
        productId: productId,
        page: next,
      );
    }
  }

  Future<void> prevPageRelated(
      {required ProductType productType, String? productId}) async {
    if (_relatedMeta != null && _relatedMeta!.currentPage > 1) {
      await fetchRelatedProducts(
        productType: productType,
        productId: productId,
        page: _relatedMeta!.currentPage - 1,
      );
    }
  }
}
