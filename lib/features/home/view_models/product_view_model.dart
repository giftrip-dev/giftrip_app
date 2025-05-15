import 'package:flutter/foundation.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/core/utils/page_meta.dart';
import 'package:giftrip/features/home/models/product_model.dart';
import 'package:giftrip/features/home/repositories/product_repo.dart';

/// 목업용 상품 리스트 (30개)
final List<ProductModel> mockProducts = List.generate(
  30,
  (index) {
    final id = index + 1;
    final originalPrice = 10000 + (index * 500);
    // 매 5번째 아이템에는 할인율 적용
    final discountRate = (index % 5 == 0) ? ((id * 2) % 50 + 10) : null;
    // 할인율이 있는 경우 최종 가격 계산, 없는 경우 원가와 동일
    final finalPrice = discountRate != null
        ? ((originalPrice * (100 - discountRate)) / 100).round()
        : originalPrice;

    // 랜덤으로 뱃지 할당 (복수 뱃지도 가능하도록)
    List<ProductTagType> badges = [];
    if (index % 3 == 0) badges.add(ProductTagType.newArrival);
    if (index % 4 == 0) badges.add(ProductTagType.bestSeller);
    if (index % 10 == 9) badges.add(ProductTagType.almostSoldOut);

    // 상품 타입 랜덤 할당
    final productTypeIndex = index % ProductType.values.length;
    final productType = ProductType.values[productTypeIndex];

    return ProductModel(
      thumbnailUrl: 'assets/png/banner.png',
      title: '테스트 상품 제목 $id',
      originalPrice: originalPrice,
      finalPrice: finalPrice,
      discountRate: discountRate,
      createdAt: DateTime.now().subtract(Duration(days: index)),
      productType: productType,
      badges: badges.isNotEmpty ? badges : null,
    );
  },
).toList();

/// 섹션 구분용 enum
enum ProductSection { newArrivals, bestSellers, timeDeals, relatedProducts }

class ProductViewModel extends ChangeNotifier {
  final ProductRepo _repo = ProductRepo();

  /// 목업 데이터를 사용할지 판단하는 플래그
  /// todo: 목업 플래그 없애기
  final bool useMock = true;

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
      if (useMock) {
        // ─ 목업 페이지네이션 로직
        final all = mockProducts;
        final pageItems = all.skip((page - 1) * limit).take(limit).toList();
        if (page == 1) {
          _newList = pageItems;
        } else {
          _newList.addAll(pageItems);
        }
        final total = all.length;
        _newMeta = PageMeta(
          totalItems: total,
          currentPage: page,
          itemsPerPage: limit,
          totalPages: (total ~/ limit) + (total % limit > 0 ? 1 : 0),
        );
      } else {
        // ─ 실제 API 호출 로직
        // final resp = await _repo.getNewProductList(page: page, limit: limit);
        // if (page == 1) {
        //   _newList = resp.items;
        // } else {
        //   _newList.addAll(resp.items);
        // }
        // _newMeta = resp.meta;
      }
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
      if (useMock) {
        // ─ 목업 페이지네이션 로직
        final all = mockProducts;
        final pageItems = all.skip((page - 1) * limit).take(limit).toList();
        if (page == 1) {
          _bestList = pageItems;
        } else {
          _bestList.addAll(pageItems);
        }
        final total = all.length;
        _bestMeta = PageMeta(
          totalItems: total,
          currentPage: page,
          itemsPerPage: limit,
          totalPages: (total ~/ limit) + (total % limit > 0 ? 1 : 0),
        );
      } else {
        // ─ 실제 API 호출 로직
        // final resp = await _repo.getBestProductList(page: page, limit: limit);
        // if (page == 1) {
        //   _bestList = resp.items;
        // } else {
        //   _bestList.addAll(resp.items);
        // }
        // _bestMeta = resp.meta;
      }
    } catch (e, st) {
      logger.e('베스트상품 조회 실패: $e\n$st');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 타임 딜 조회 (목업/실제 API 분기)
  Future<void> fetchTimeDealProducts({int page = 1, int limit = 10}) async {
    _isLoading = true;
    notifyListeners();

    // UX 완화를 위한 지연
    await Future.delayed(Duration(milliseconds: page == 1 ? 100 : 300));

    try {
      if (useMock) {
        // ─ 목업 페이지네이션 로직
        final all = mockProducts;
        final pageItems = all.skip((page - 1) * limit).take(limit).toList();
        if (page == 1) {
          _timeDealList = pageItems;
        } else {
          _timeDealList.addAll(pageItems);
        }
        final total = all.length;
        _timeDealMeta = PageMeta(
          totalItems: total,
          currentPage: page,
          itemsPerPage: limit,
          totalPages: (total ~/ limit) + (total % limit > 0 ? 1 : 0),
        );
      } else {
        // ─ 실제 API 호출 로직
        // final resp = await _repo.getTimeDealProductList(page: page, limit: limit);
        // if (page == 1) {
        //   _timeDealList = resp.items;
        // } else {
        //   _timeDealList.addAll(resp.items);
        // }
        // _timeDealMeta = resp.meta;
      }
    } catch (e, st) {
      logger.e('타임 딜 조회 실패: $e\n$st');
    } finally {
      _isLoading = false;
    }
  }

  /// 관련 상품 조회 (목업/실제 API 분기)
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
      if (useMock) {
        // ─ 목업 페이지네이션 로직
        // 상품 타입에 따라 필터링
        final all =
            mockProducts.where((p) => p.productType == productType).toList();

        // 현재 상품 ID와 다른 상품들만 선택
        final filtered = productId != null
            ? all.where((p) => p.title != '테스트 상품 제목 $productId').toList()
            : all;

        final pageItems =
            filtered.skip((page - 1) * limit).take(limit).toList();

        if (page == 1) {
          _relatedList = pageItems;
        } else {
          _relatedList.addAll(pageItems);
        }

        final total = filtered.length;
        _relatedMeta = PageMeta(
          totalItems: total,
          currentPage: page,
          itemsPerPage: limit,
          totalPages: (total ~/ limit) + (total % limit > 0 ? 1 : 0),
        );
      } else {
        // ─ 실제 API 호출 로직
        // final resp = await _repo.getRelatedProducts(
        //   productType: productType,
        //   productId: productId,
        //   page: page,
        //   limit: limit,
        // );
        // if (page == 1) {
        //   _relatedList = resp.items;
        // } else {
        //   _relatedList.addAll(resp.items);
        // }
        // _relatedMeta = resp.meta;
      }
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
