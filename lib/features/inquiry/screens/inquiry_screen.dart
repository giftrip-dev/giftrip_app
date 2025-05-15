import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/banner/event_banner.dart';
import 'package:giftrip/features/home/widgets/home_app_bar.dart';

class InquiryScreen extends StatefulWidget {
  const InquiryScreen({super.key});

  @override
  _InquiryScreenState createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Column(
        children: [
          const EventBannerWidget(),
          Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              children: [
                Text('이벤트 페이지'),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
