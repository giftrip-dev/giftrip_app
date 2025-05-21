import 'package:flutter/material.dart';

import 'package:giftrip/core/widgets/app_bar/back_button_app_bar.dart';

class ReservationListScreen extends StatefulWidget {
  const ReservationListScreen({super.key});

  @override
  State<ReservationListScreen> createState() => _ReservationListScreenState();
}

class _ReservationListScreenState extends State<ReservationListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackButtonAppBar(
        type: BackButtonAppBarType.textLeft,
        title: '예약 내역',
      ),
    );
  }
}
