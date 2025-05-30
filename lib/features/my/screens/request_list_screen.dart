import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/app_bar/back_button_app_bar.dart';
import 'package:giftrip/features/my/models/request_model.dart';
import 'package:giftrip/features/my/view_models/mypage_view_model.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/features/my/widgets/request_list.dart';

class RequestListScreen extends StatefulWidget {
  const RequestListScreen({super.key});

  @override
  State<RequestListScreen> createState() => _RequestListScreenState();
}

class _RequestListScreenState extends State<RequestListScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<RequestModel> _requests = [];
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
          .getRequestList(page: _currentPage, limit: _limit);
      setState(() {
        _requests.addAll(response.items);
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
          .getRequestList(page: _currentPage, limit: _limit);
      setState(() {
        _requests.addAll(response.items);
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
        title: '취소,반품,교환 목록',
      ),
      body: _requests.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _requests.clear();
                  _currentPage = 1;
                  _hasMore = true;
                });
                await _loadInitialData();
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _requests.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _requests.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: RequestList(requests: [_requests[index]]),
                  );
                },
              ),
            ),
    );
  }
}
