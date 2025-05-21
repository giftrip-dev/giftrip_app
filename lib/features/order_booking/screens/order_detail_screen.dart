import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/app_bar/home_app_bar.dart';
import 'package:giftrip/features/order_booking/models/order_booking_model.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderBookingModel orderBooking;

  const OrderDetailScreen({
    super.key,
    required this.orderBooking,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(title: '주문 상세'),
      body: Center(
        child: Text('주문 상세 화면: ${orderBooking.title}'),
      ),
    );
  }
}
