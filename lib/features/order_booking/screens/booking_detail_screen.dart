import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/app_bar/home_app_bar.dart';
import 'package:giftrip/features/order_booking/models/order_booking_model.dart';

class BookingDetailScreen extends StatelessWidget {
  final OrderBookingModel orderBooking;

  const BookingDetailScreen({
    super.key,
    required this.orderBooking,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(title: '예약 상세'),
      body: Center(
        child: Text('예약 상세 화면: ${orderBooking.title}'),
      ),
    );
  }
}
