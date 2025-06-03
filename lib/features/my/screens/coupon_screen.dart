import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/app_bar/back_button_app_bar.dart';
import 'package:giftrip/features/my/models/coupon_model.dart';
import 'package:giftrip/features/my/view_models/mypage_view_model.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/features/my/widgets/coupon_item.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<CouponModel> _coupons = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  static const int _limit = 10;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final response = await MyPageViewModel()
          .getCouponList(page: _currentPage, limit: _limit);
      setState(() {
        _coupons.addAll(response.items);
        _hasMore = _currentPage < response.meta.totalPages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('데이터를 불러오지 못했습니다.')),
        );
      }
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMore) return;
    setState(() => _isLoading = true);

    try {
      _currentPage++;
      final response = await MyPageViewModel()
          .getCouponList(page: _currentPage, limit: _limit);
      setState(() {
        _coupons.addAll(response.items);
        _hasMore = _currentPage < response.meta.totalPages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('추가 데이터를 불러오지 못했습니다.')),
        );
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMoreData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackButtonAppBar(
        type: BackButtonAppBarType.textCenter,
        title: '쿠폰함',
      ),
      body: _coupons.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        '사용 가능 쿠폰 ',
                        style:
                            subtitle_XS.copyWith(color: AppColors.labelStrong),
                      ),
                      Text(
                        '${_coupons.length}',
                        style: subtitle_XS.copyWith(
                            color: AppColors.primaryStrong),
                      ),
                      Text(
                        '개',
                        style: subtitle_XS.copyWith(color: AppColors.label),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      ..._coupons
                          .map((coupon) => CouponItem(coupon: coupon))
                          .toList(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
