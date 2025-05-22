import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/app_bar/search_app_bar.dart';
import 'package:giftrip/features/root/screens/root_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        title: '장바구니',
        onBackPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RootScreen(selectedIndex: 0),
          ),
        ),
      ),
      body: Column(
        children: [
          Text('장바구니'),
        ],
      ),
    );
  }
}
