import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/features/notification/widgets/notification_item.dart';
import 'package:giftrip/features/notification/view_models/notification_view_model.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/utils/amplitude_logger.dart';
import 'package:giftrip/features/notification/widgets/notification_app_bar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationViewModel _notificationVM;

  @override
  void initState() {
    super.initState();
    _notificationVM = context.read<NotificationViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationVM.fetchNotificationList();
    });

    AmplitudeLogger.logViewEvent(
      'app_notification_screen_view',
      'app_notification_screen',
    );
  }

  @override
  Widget build(BuildContext context) {
    final notificationVM = context.watch<NotificationViewModel>();
    return PopScope(
      // 화면을 나갈 때 읽지 않은 알림 목록 갱신
      canPop: true,
      onPopInvoked: (didPop) async {
        if (didPop) {
          await _notificationVM.fetchUnreadNotificationList();
        }
      },
      child: Scaffold(
        appBar: NotificationAppBar(
          title: '알림',
          onBack: () {
            // 뒤로가기 버튼 클릭 시 읽지 않은 알림 목록 갱신
            _notificationVM.fetchUnreadNotificationList().then((_) {
              Navigator.pop(context);
            });
          },
          onDeleteAll: () {
            _notificationVM.deleteAllNotification();
          },
          onReadAll: () {
            _notificationVM.readAllNotification();
          },
        ),
        body: notificationVM.notificationList.isEmpty
            ? Center(
                child: Text(
                  '새로운 알림이 없습니다',
                  style: subtitle_L.copyWith(color: AppColors.labelAssistive),
                ),
              )
            : ListView(
                children: notificationVM.notificationList.map((notification) {
                  return NotificationItem(
                    notification: notification,
                    viewModel: notificationVM,
                  );
                }).toList(),
              ),
      ),
    );
  }
}
