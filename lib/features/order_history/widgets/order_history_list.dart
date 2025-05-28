import 'package:flutter/material.dart';
import 'package:giftrip/features/order_history/models/order_history_model.dart';
import 'package:giftrip/features/order_history/widgets/order_history_list_item.dart';

class OrderHistoryList extends StatefulWidget {
  final List<OrderHistoryModel> orderBookings;
  final bool isLoading;
  final bool hasError;
  final VoidCallback? onLoadMore;

  const OrderHistoryList({
    super.key,
    required this.orderBookings,
    this.isLoading = false,
    this.hasError = false,
    this.onLoadMore,
  });

  @override
  State<OrderHistoryList> createState() => _OrderHistoryListState();
}

class _OrderHistoryListState extends State<OrderHistoryList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (widget.onLoadMore != null &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !widget.isLoading) {
      widget.onLoadMore!();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hasError) {
      return const Center(
        child: Text('데이터를 불러오는데 실패했습니다.'),
      );
    }

    if (widget.orderBookings.isEmpty && !widget.isLoading) {
      return const Center(
        child: Text('예약 내역이 없습니다.'),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 16),
        itemCount:
            widget.orderBookings.length + (widget.onLoadMore != null ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index == widget.orderBookings.length) {
            if (widget.isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return const SizedBox.shrink();
          }

          return OrderHistoryListItem(
            orderBooking: widget.orderBookings[index],
          );
        },
      ),
    );
  }
}
