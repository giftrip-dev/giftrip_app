import 'package:flutter/material.dart';
import 'package:giftrip/features/delivery/models/delivery_model.dart';
import 'package:giftrip/features/delivery/widgets/delivery_item.dart';

class DeliveryList extends StatefulWidget {
  final List<DeliveryModel> deliveries;
  final bool isLoading;
  final bool hasError;
  final VoidCallback? onLoadMore;

  const DeliveryList({
    super.key,
    required this.deliveries,
    this.isLoading = false,
    this.hasError = false,
    this.onLoadMore,
  });

  @override
  State<DeliveryList> createState() => _DeliveryListState();
}

class _DeliveryListState extends State<DeliveryList> {
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

    if (widget.deliveries.isEmpty && !widget.isLoading) {
      return const Center(
        child: Text('배송 내역이 없습니다.'),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.deliveries.length + (widget.onLoadMore != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == widget.deliveries.length) {
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

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              DeliveryItem(
                delivery: widget.deliveries[index],
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
