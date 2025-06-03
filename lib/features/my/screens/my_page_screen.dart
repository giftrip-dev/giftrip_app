import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/features/my/widgets/my_page_box.dart';
import 'package:giftrip/features/my/widgets/switch_box.dart';
import 'package:giftrip/features/my/widgets/my_info_box.dart';
import 'package:giftrip/features/my/view_models/mypage_view_model.dart';
import 'package:giftrip/core/widgets/modal/outline_two_button_modal.dart';
import 'package:giftrip/features/auth/view_models/auth_view_model.dart';
import 'package:giftrip/features/root/screens/root_screen.dart';
import 'package:provider/provider.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  late MyPageViewModel myPageViewModel;
  late MyPageViewModel userViewModel;
  late AuthViewModel authViewModel;
  bool userIsInfluencer = false;
  String userName = '';
  int userPoint = 0;
  int userCoponCount = 0;
  bool marketingAgree = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        myPageViewModel = Provider.of<MyPageViewModel>(context, listen: false);
        userViewModel = Provider.of<MyPageViewModel>(context, listen: false);
        authViewModel = Provider.of<AuthViewModel>(context, listen: false);
        _loadUserInfo();
      }
    });
  }

  void _loadUserInfo() async {
    if (!mounted) return;
    var userInfo = await userViewModel.getUserInfo();
    if (!mounted) return;
    // if (userInfo != null) {
    //   setState(() {
    //     userNickname = userInfo.nickname; // 닉네임 저장
    //     userEmail = userInfo.email; // 이메일 저장
    //   });
    // }
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
                  MyInfoBox(
                    isInfluencer: userIsInfluencer,
                    // nickname: userName,
                    point: int.parse(userPoint.toString()),
                    couponCount: int.parse(userCoponCount.toString()),
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
                            myPageViewModel.onTapRequestList(context),
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
                        // 'onTap': () => myPageViewModel.onTapLogin(context),
                        // () {},
                      },
                    },
                  ),
                  SwitchBox(
                    marketingAgree: marketingAgree,
                  ),
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
                        'onTap': () {
                          final authViewModel = Provider.of<AuthViewModel>(
                              context,
                              listen: false);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return OutlineTwoButtonModal(
                                title: '로그아웃을 진행하시나요?',
                                cancelText: '취소',
                                confirmText: '로그아웃',
                                onConfirm: () async {
                                  final result = await authViewModel.logout();
                                  if (result != null) {
                                    // 로그아웃 성공 시 RootScreen으로 이동 (기존 스택 모두 제거)
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => result),
                                      (route) => false,
                                    );
                                    // 로그아웃 성공 메시지
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('로그아웃 되었습니다.')),
                                    );
                                  } else {
                                    // 실패 시 에러 처리 (필요시)
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('로그아웃에 실패했습니다.')),
                                    );
                                  }
                                },
                                onCancel: () {
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          );
                        },
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
