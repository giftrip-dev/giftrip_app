import 'package:flutter/material.dart';
import 'package:myong/core/widgets/banner/event_banner.dart';
import 'package:myong/features/home/widgets/home_app_bar.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
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
