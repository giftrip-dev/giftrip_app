import 'package:flutter/material.dart';
import 'package:myong/core/widgets/app_bar/global_app_bar.dart';
import 'package:myong/features/my/widgets/certificate_board.dart';
import 'package:myong/features/my/widgets/account_box.dart';
import 'package:myong/features/my/widgets/mypage_box.dart';
import 'package:myong/features/my/view_models/mypage_view_model.dart';
import 'package:myong/features/my/widgets/config_box.dart';
import 'package:myong/features/user/view_models/user_view_model.dart';
import 'package:myong/features/user/view_models/certificate_view_model.dart';
import 'package:myong/features/user/models/certificate_model.dart';
import 'package:myong/core/utils/amplitude_logger.dart';
import 'package:myong/core/services/storage_service.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  late MyPageViewModel myPageViewModel;
  late UserViewModel userViewModel;
  late CertificateViewModel certificateViewModel;
  List<CertificateModel>? certificates;
  // userInfo 변수를 추가합니다.
  String? userNickname;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    myPageViewModel = MyPageViewModel();
    userViewModel = UserViewModel();
    certificateViewModel = CertificateViewModel();
    // getUserInfo 호출하여 사용자 정보를 가져옵니다.
    _loadUserInfo();
    _loadCertificate();
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

  void _loadCertificate() async {
    var loadedCertificates = await certificateViewModel.getCertificate();
    if (loadedCertificates != null) {
      setState(() {
        this.certificates = loadedCertificates;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CertificateBoard(certificates: certificates),
                    ],
                  ),
                  // AccountBoxWidget에 userNickname과 userEmail을 전달합니다.
                  AccountBoxWidget(
                    nickname: userNickname ?? '',
                    email: userEmail ?? '',
                  ),
                  MyPageBox(
                    title: '커뮤니티',
                    myPageInfo: {
                      '내가 작성한 게시글': {
                        'onTap': () => myPageViewModel.onTapMyPosts(context),
                      },
                    },
                  ),
                  ConfigBox(),
                  MyPageBox(
                    title: '이용 안내',
                    myPageInfo: {
                      '앱버전': {
                        'text': 'v1.0.6',
                        'onTap': myPageViewModel.onTapAppVersion,
                      },
                      '카카오톡 문의': {
                        'onTap': () => myPageViewModel.onTapContact(context),
                      },
                      '공지사항': {
                        'onTap': () => myPageViewModel.onTapNotice(context),
                      },
                      '서비스 이용 약관': {
                        'onTap': () => myPageViewModel.onTapTerms(context),
                      },
                      '개인정보 처리 방침': {
                        'onTap': () =>
                            myPageViewModel.onTapPrivacyPolicy(context),
                      },
                      '로그아웃': {
                        // 'onTap': () => GlobalStorage().deleteAccessToken(),
                        'onTap': () => myPageViewModel.onTapLogout(context),
                      },
                      '문의/신고': {
                        'text': 'daggle@daggle.io',
                      },
                      '회원탈퇴': {
                        'onTap': () => myPageViewModel.onTapWithdraw(context),
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
