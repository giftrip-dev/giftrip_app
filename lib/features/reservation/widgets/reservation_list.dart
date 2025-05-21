import 'package:flutter/material.dart';
import 'package:giftrip/features/reservation/models/reservation_model.dart';
import 'package:giftrip/features/reservation/widgets/reservation_item.dart';

class ReservationList extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (hasError) {
      return const Center(
        child: Text('데이터를 불러오는데 실패했습니다.'),
      );
    }

    if (reservations.isEmpty && !isLoading) {
      return const Center(
        child: Text('예약 내역이 없습니다.'),
      );
    }

    return ListView.builder(
      itemCount: reservations.length + (onLoadMore != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == reservations.length) {
          if (isLoading) {
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
          reservation: reservations[index],
        );
      },
    );
  }
}
