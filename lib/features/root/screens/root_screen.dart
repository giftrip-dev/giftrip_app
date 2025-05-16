import 'package:flutter/material.dart';
import 'package:giftrip/core/widgets/gnb/bottom_gnb.dart';
import 'package:giftrip/features/home/screens/home_screen.dart';
import 'package:giftrip/core/enum/community_enum.dart';
import 'package:giftrip/core/utils/amplitude_logger.dart';
import 'package:giftrip/features/category/category_screen.dart';
import 'package:giftrip/features/auth/screens/login_screen.dart';

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
        const HomeScreen(),
        const LoginScreen(),
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
      // bottomNavigationBar: BottomGnb(
      //   selectedIndex: selectedIndex,
      //   onTap: onItemTapped,
      // ),
      // 로그인 화면에서는 메뉴바 숨김(시연 영상용)
      bottomNavigationBar: selectedIndex == 3
          ? null
          : BottomGnb(
              selectedIndex: selectedIndex,
              onTap: onItemTapped,
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
        return const HomeScreen(key: ValueKey('home'));
      case 3:
        return const LoginScreen(key: ValueKey('login'));
      default:
        return const HomeScreen(key: ValueKey('home'));
    }
  }
}
