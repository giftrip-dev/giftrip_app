import 'package:flutter/material.dart';
import 'package:myong/core/services/storage_service.dart';
import 'package:myong/core/widgets/gnb/bottom_gnb.dart';
import 'package:myong/features/community/screens/community_screen.dart';
import 'package:myong/features/community/screens/search_screen.dart';
import 'package:myong/features/home/screens/home_screen.dart';
import 'package:myong/features/my/screens/my_page_screen.dart';
import 'package:myong/features/community/screens/write_screen.dart';
import 'package:myong/core/enum/community_enum.dart';
import 'package:myong/core/utils/amplitude_logger.dart';
import 'package:myong/core/widgets/modal/one_button_modal.dart';

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
        CommunityScreen(initialSort: currentSort ?? PostSortType.latest),
        const SizedBox(),
        const SearchScreen(),
        const MyPageScreen(),
      ];

  // 글 작성 페이지 이동 핸들러
  Future<void> handleWriteScreenNavigation() async {
    final user = await GlobalStorage().getUserInfo();
    // 자격 인증 완료
    if (user?.certificateStatus == "ACCEPTED") {
      setState(() {
        selectedIndex = 2;
      });
      AmplitudeLogger.logClickEvent("write_tab_click", "gnb_write_tab", "gnb");
    }
    // 자격 인증 미완료
    else {
      // setState(() {
      //   selectedIndex = 2;
      // });
      String title = "자격 인증 필요";
      String desc = "자격증 인증 완료 후 게시글 작성이 가능해요.";
      // 자격 인증 진행 중
      if (user?.certificateStatus == "PENDING") {
        title = "자격 인증 필요";
        desc = "자격증 검토 완료 후 게시글 작성이 가능해요.";
      }
      showDialog(
        context: context,
        builder: (context) => OneButtonModal(
          title: title,
          desc: desc,
          onConfirm: () => Navigator.of(context).pop(),
        ),
      );
    }
  }

  void onItemTapped(int index) async {
    // 현재 선택된 탭과 같은 탭을 클릭한 경우 무시
    if (selectedIndex == index) return;

    if (index == 2) {
      handleWriteScreenNavigation();
    } else {
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
        case 3:
          await AmplitudeLogger.logClickEvent(
              "search_tab_click", "gnb_search_tab", "gnb");
          break;
        case 4:
          await AmplitudeLogger.logClickEvent(
              "mypage_tab_click", "gnb_mypage_tab", "gnb");
          break;
      }
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
      bottomNavigationBar: selectedIndex == 2
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
        return CommunityScreen(
          key: const ValueKey('community'),
          initialSort: currentSort ?? PostSortType.latest,
        );
      case 2:
        return const WriteScreen(key: ValueKey('write'));
      case 3:
        return const SearchScreen(key: ValueKey('search'));
      case 4:
        return const MyPageScreen(key: ValueKey('mypage'));
      default:
        return const HomeScreen(key: ValueKey('home'));
    }
  }
}
