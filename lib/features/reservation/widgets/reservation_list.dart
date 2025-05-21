import 'package:flutter/material.dart';
import 'package:giftrip/features/reservation/models/reservation_model.dart';
import 'package:giftrip/features/reservation/widgets/reservation_item.dart';

class ReservationList extends StatefulWidget {
  final List<ReservationModel> reservations;
  final bool isLoading;
  final bool hasError;
  final VoidCallback? onLoadMore;

  const ReservationList({
    super.key,
    required this.reservations,
    this.isLoading = false,
    this.hasError = false,
    this.onLoadMore,
  });

  @override
  State<ReservationList> createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
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

    if (widget.reservations.isEmpty && !widget.isLoading) {
      return const Center(
        child: Text('예약 내역이 없습니다.'),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount:
          widget.reservations.length + (widget.onLoadMore != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == widget.reservations.length) {
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

        return ReservationItem(
          reservation: widget.reservations[index],
        );
      },
    );
  }
}
