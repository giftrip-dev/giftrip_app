import 'package:flutter/material.dart';
import 'package:giftrip/features/my/widgets/mypage_box.dart';
import 'package:giftrip/features/my/view_models/mypage_view_model.dart';
import 'package:giftrip/features/user/view_models/user_view_model.dart';
import 'package:giftrip/core/utils/amplitude_logger.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  late MyPageViewModel myPageViewModel;
  late UserViewModel userViewModel;

  // userInfo 변수를 추가합니다.
  String? userNickname;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    myPageViewModel = MyPageViewModel();
    userViewModel = UserViewModel();
    // getUserInfo 호출하여 사용자 정보를 가져옵니다.
    _loadUserInfo();
    AmplitudeLogger.logViewEvent(
        "app_my_page_screen_view", "app_my_page_screen");
  }

  // 사용자 정보를 로드하는 메서드
  void _loadUserInfo() async {
    var userInfo = await userViewModel.getUserInfo();
    if (userInfo != null) {
      setState(() {
        userNickname = userInfo.nickname; // 닉네임 저장
        userEmail = userInfo.email; // 이메일 저장
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyPageBox(
                    title: '페이지 이동',
                    myPageInfo: {
                      '로그인': {
                        'onTap': () => myPageViewModel.onTapLogin(context),
                      },
                      '주문/예약 목록': {
                        'onTap': () =>
                            myPageViewModel.onTapReservationList(context),
                      },
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
