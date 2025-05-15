import 'package:flutter/material.dart';
import 'package:giftrip/features/event/models/event_model.dart';
import 'package:giftrip/features/event/widgets/event_item.dart';

class EventList extends StatelessWidget {
  final List<EventModel> events;
  final bool isLoading;
  final VoidCallback onRefresh;
  final VoidCallback onLoadMore;

  const EventList({
    super.key,
    required this.events,
    required this.isLoading,
    required this.onRefresh,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    // 초기 로딩 상태일 때 (데이터가 없고 로딩 중일 때)
    if (events.isEmpty && isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!isLoading &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            onLoadMore();
          }
          return true;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomScrollView(
            slivers: [
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 16,
                  mainAxisExtent: 239,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => EventItem(event: events[index]),
                  childCount: events.length,
                ),
              ),
              // 페이지네이션 로딩 인디케이터 (데이터가 있을 때만 표시)
              if (isLoading && events.isNotEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
