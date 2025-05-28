import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/features/my/widgets/my_page_box.dart';
import 'package:giftrip/features/my/widgets/switch_box.dart';
import 'package:giftrip/features/my/widgets/user_info_box.dart';
import 'package:giftrip/features/my/view_models/mypage_view_model.dart';
import 'package:giftrip/features/user/view_models/user_view_model.dart';
import 'package:giftrip/core/widgets/modal/outline_two_button_modal.dart';

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
      appBar: AppBar(
        title: const Text('마이페이지', style: title_M),
        titleSpacing: 16,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserInfoBox(
                    isInfluencer: true,
                    nickname: '홍길동',
                    point: 123456,
                    couponCount: 2,
                  ),
                  MyPageBox(
                    title: '주문 관리',
                    myPageInfo: {
                      // '로그인': {
                      //   'onTap': () => myPageViewModel.onTapLogin(context),
                      // },
                      '주문/예약 목록': {
                        'onTap': () =>
                            myPageViewModel.onTapOrderBookingList(context),
                      },
                      '배송 목록': {
                        'onTap': () =>
                            myPageViewModel.onTapDeliveryList(context),
                      },
                      '취소,반품,교환 목록': {
                        'onTap': () =>
                            // myPageViewModel.onTapCancelRefundExchangeList(context),
                            () {},
                      },
                      '리뷰 작성': {
                        'onTap': () =>
                            // myPageViewModel.onTapReviewWrite(context),
                            () {},
                      },
                    },
                  ),
                  MyPageBox(
                    title: '고객센터',
                    myPageInfo: {
                      '1:1 문의하기': {
                        'onTap': () =>
                            // myPageViewModel.onTapReviewWrite(context),
                            () {},
                      },
                    },
                  ),
                  SwitchBox(),
                  MyPageBox(
                    title: '기타',
                    showIcon: false,
                    myPageInfo: {
                      '공지사항': {
                        'onTap': () =>
                            // myPageViewModel.onTapReviewWrite(context),
                            () {},
                      },
                      '로그아웃': {
                        'onTap': () => showDialog(
                              context: context,
                              builder: (context) {
                                return OutlineTwoButtonModal(
                                  title: '로그아웃을 진행하시나요?',
                                  cancelText: '취소',
                                  confirmText: '로그아웃',
                                  onConfirm: () {
                                    Navigator.of(context).pop();
                                  },
                                  onCancel: () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            ),
                      },
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
