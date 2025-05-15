import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/app_bar/search_app_bar.dart';
import 'package:giftrip/features/event/view_models/event_view_model.dart';
import 'package:giftrip/features/event/widgets/event_list.dart';
import 'package:provider/provider.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  void initState() {
    super.initState();
    // 화면이 처음 로드될 때 이벤트 목록을 불러옵니다
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventViewModel>().fetchEventList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(title: '이벤트'),
      body: Consumer<EventViewModel>(
        builder: (context, viewModel, child) {
          return EventList(
            events: viewModel.eventList,
            isLoading: viewModel.isLoading,
            onRefresh: () => viewModel.fetchEventList(refresh: true),
            onLoadMore: () {
              if (viewModel.nextPage != null) {
                viewModel.fetchEventList();
              }
            },
          );
        },
      ),
    );
  }
}
