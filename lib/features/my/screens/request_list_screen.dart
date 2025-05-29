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
  Future<List<RequestModel>>? _requestListFuture;

  @override
  void initState() {
    super.initState();
    _requestListFuture = MyPageViewModel().getRequestList();
  }

  @override
  Widget build(BuildContext context) {
    if (_requestListFuture == null) {
      // 혹시 모를 예외 처리
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: const BackButtonAppBar(
        type: BackButtonAppBarType.textCenter,
        title: '취소,반품,교환 목록',
      ),
      body: FutureBuilder<List<RequestModel>>(
        future: _requestListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('데이터를 불러오지 못했습니다.'));
          }
          final requests = snapshot.data ?? [];
          return RequestList(requests: requests);
        },
      ),
    );
  }
}
