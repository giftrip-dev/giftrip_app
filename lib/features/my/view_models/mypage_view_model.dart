import 'package:flutter/material.dart';
import 'package:giftrip/core/utils/pdf_download.dart';
import 'package:giftrip/core/services/storage_service.dart';
// import 'package:giftrip/core/widgets/modal/one_button_modal.dart';
import 'package:giftrip/features/my/screens/user_management_screen.dart';
import 'package:giftrip/features/auth/repositories/auth_repo.dart';
import 'package:giftrip/features/leave/screens/feedback_screen.dart';
import 'package:giftrip/features/notice/screens/notice_screen.dart';
import 'package:giftrip/features/auth/screens/login_screen.dart';
import 'package:giftrip/features/notification/view_models/notification_view_model.dart';
import 'package:giftrip/features/order_history/screens/order_history_screen.dart';
import 'package:giftrip/features/my/screens/request_list_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:giftrip/core/utils/amplitude_logger.dart';
import 'package:giftrip/features/delivery/screens/delivery_screen.dart';
import 'package:giftrip/features/my/repositories/mypage_repo.dart';
import 'package:giftrip/features/my/models/user_model.dart';
import 'package:giftrip/features/my/models/request_model.dart';

class MyPageViewModel extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();
  final NotificationViewModel _notificationViewModel = NotificationViewModel();
  final GlobalStorage _storage = GlobalStorage();
  final MyPageRepository _repository = MyPageRepository();

  void onTapAppVersion() {}

  void onTapContact(context) {
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return OneButtonModal(
    //       title: "문의 안내",
    //       desc: "contact@daggle.io로 문의해주세요.\n빠르게 답변 받을 수 있어요.",
    //       onConfirm: () {
    //         Navigator.of(context).pop();
    //       },
    //     );
    //   },
    // );
    // 카카오톡 채널 연결
    launchUrl(Uri.parse('http://pf.kakao.com/_mxhUxjn'));
    AmplitudeLogger.logClickEvent(
      'kakao_contact_click',
      'kakao_contact_button',
      'my_page',
    );
  }

  Future<UserModel> getUserInfo() async {
    return await _repository.getUserInfo();
  }

  Future<UserModel> getUserManagement() async {
    return await _repository.getUserManagement();
  }

  Future<RequestPageResponse> getRequestList({
    int page = 1,
    int limit = 10,
  }) async {
    return await _repository.getRequestList(
      page: page,
      limit: limit,
    );
  }

  Future<CouponPageResponse> getCouponList({
    int page = 1,
    int limit = 10,
  }) async {
    return await _repository.getCouponList(
      page: page,
      limit: limit,
    );
  }

  void onTapUserDetail(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserManagementScreen()),
    );
  }

  void onTapNotice(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NoticeScreen()),
    );
    AmplitudeLogger.logClickEvent(
      'notice_click',
      'notice_button',
      'my_page',
    );
  }

  void onTapTerms(context) {
    PdfDownloadUtil.downloadPdf(
      context: context,
      assetPath: 'assets/service-terms.pdf',
      fileName: 'service-terms.pdf',
    );
    AmplitudeLogger.logClickEvent(
      'service_terms_click',
      'service_terms_button',
      'my_page',
    );
  }

  void onTapPrivacyPolicy(context) {
    PdfDownloadUtil.downloadPdf(
      context: context,
      assetPath: 'assets/privacy-policy.pdf',
      fileName: 'privacy-policy.pdf',
    );
    AmplitudeLogger.logClickEvent(
      'privacy_policy_click',
      'privacy_policy_button',
      'my_page',
    );
  }

  void onTapLogin(BuildContext context) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
    AmplitudeLogger.logClickEvent(
      'logout_click',
      'logout_button',
      'my_page',
    );
  }

  void onTapOrderBookingList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
    );
  }

  void onTapDeliveryList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DeliveryScreen()),
    );
  }

  void onTapRequestList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RequestListScreen()),
    );
  }

  void onTapWithdraw(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FeedbackScreen()),
    );
    AmplitudeLogger.logClickEvent(
      'withdraw_click',
      'withdraw_button',
      'my_page',
    );
  }
}
