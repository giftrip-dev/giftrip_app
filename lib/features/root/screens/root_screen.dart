import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/gnb/bottom_gnb.dart';
import 'package:giftrip/features/home/screens/home_screen.dart';
import 'package:giftrip/core/enum/community_enum.dart';
import 'package:giftrip/core/utils/amplitude_logger.dart';
import 'package:giftrip/features/category/category_screen.dart';
import 'package:giftrip/features/cart/screens/cart_screen.dart';
import 'package:giftrip/features/my/screens/my_page_screen.dart';
import 'package:giftrip/features/auth/screens/login_screen.dart';
import 'package:giftrip/core/storage/auth_storage.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({
    Key? key,
    this.selectedIndex = 0,
    this.initialSort,
  }) : super(key: key);

  final int selectedIndex;
  final PostSortType? initialSort;

  @override
  RootScreenState createState() => RootScreenState();
}

class RootScreenState extends State<RootScreen> {
  late int selectedIndex;
  PostSortType? currentSort;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
    currentSort = widget.initialSort;
  }

  List<Widget> get pages => [
        const HomeScreen(),
        const CategoryScreen(),
        const CartScreen(),
        const MyPageScreen(),
      ];

  void onItemTapped(int index) async {
    // 현재 선택된 탭과 같은 탭을 클릭한 경우 무시
    if (selectedIndex == index) return;

    setState(() {
      _isLoading = true;
      selectedIndex = index;
      if (index != 1) {
        currentSort = null;
      }
    });

    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _isLoading = false;
    });

    // Log GNB tab click events
    switch (index) {
      case 0:
        await AmplitudeLogger.logClickEvent(
            "home_tab_click", "gnb_home_tab", "gnb");
        break;
      case 1:
        await AmplitudeLogger.logClickEvent(
            "community_tab_click", "gnb_community_tab", "gnb");
        break;
      case 2:
        await AmplitudeLogger.logClickEvent(
            "write_tab_click", "gnb_write_tab", "gnb");
        break;
      case 3:
        await AmplitudeLogger.logClickEvent(
            "mypage_tab_click", "gnb_mypage_tab", "gnb");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int? initialIndex =
        ModalRoute.of(context)?.settings.arguments as int?;
    if (initialIndex != null && initialIndex != selectedIndex) {
      setState(() {
        selectedIndex = initialIndex;
      });
    }

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildCurrentScreen(),
      ),
      bottomNavigationBar: FutureBuilder<bool>(
        future: AuthStorage().getAutoLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }

          final isAutoLogin = snapshot.data ?? false;
          if (selectedIndex == 3 && !isAutoLogin) {
            return const SizedBox.shrink();
          }

          return selectedIndex == 2
              ? const SizedBox.shrink()
              : BottomGnb(
                  selectedIndex: selectedIndex,
                  onTap: onItemTapped,
                );
        },
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (selectedIndex) {
      case 0:
        return const HomeScreen(key: ValueKey('home'));
      case 1:
        return const CategoryScreen(key: ValueKey('category'));
      case 2:
        return const CartScreen(key: ValueKey('cart'));
      case 3:
        return FutureBuilder<bool>(
          future: AuthStorage().getAutoLogin(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final isAutoLogin = snapshot.data ?? false;
            if (!isAutoLogin) {
              return const LoginScreen(key: ValueKey('login'));
            }
            return const MyPageScreen(key: ValueKey('myPage'));
          },
        );
      default:
        return const HomeScreen(key: ValueKey('home'));
    }
  }
}
