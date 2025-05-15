import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/features/notification/screens/notification_screen.dart';
import 'package:giftrip/features/notification/view_models/notification_view_model.dart';
import 'package:provider/provider.dart';

class GlobalAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool noAlarm;
  final bool noNotification;

  const GlobalAppBar({
    super.key,
    this.noAlarm = false,
    this.noNotification = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  State<GlobalAppBar> createState() => _GlobalAppBarState();
}

class _GlobalAppBarState extends State<GlobalAppBar> {
  @override
  void initState() {
    super.initState();

    // noAlarm이 false일 때만 읽지 않은 알림 목록 조회
    if (!widget.noAlarm) {
      // initState에서는 바로 호출하면 오류가 발생할 수 있으므로 약간 지연
      Future.microtask(() {
        if (mounted) {
          Provider.of<NotificationViewModel>(context, listen: false)
              .fetchUnreadNotificationList();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      leadingWidth: 100,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: GestureDetector(
          child: SizedBox(
            width: 68,
            height: 20,
            child: Image.asset(
              'assets/images/logo/logo_sm.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      actions: widget.noAlarm
          ? null
          : [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 23, vertical: 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationScreen()),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.topRight,
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        LucideIcons.bell,
                        size: 28,
                      ),
                      Consumer<NotificationViewModel>(
                        builder: (context, notificationViewModel, child) {
                          // 읽지 않은 알림이 있는지 확인
                          final hasUnreadNotifications =
                              notificationViewModel.notificationList.isNotEmpty;

                          // final notificationCount =
                          //     notificationViewModel.notificationList.length;

                          // 읽지 않은 알림이 없으면 빈 컨테이너 반환
                          if (!hasUnreadNotifications ||
                              widget.noNotification) {
                            return const SizedBox.shrink();
                          }

                          // 읽지 않은 알림이 있으면 빨간 점 표시
                          return Positioned(
                            right: -3,
                            top: -6,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.statusAlarmDot,
                                shape: BoxShape.circle,
                              ),
                              // child: Center(
                              //   child: FittedBox(
                              //     fit: BoxFit.scaleDown,
                              //     child: Padding(
                              //       padding: const EdgeInsets.all(2.0),
                              //       child: Text(
                              //         notificationCount.toString(),
                              //         textAlign: TextAlign.center,
                              //         style: const TextStyle(
                              //           color: Colors.white,
                              //           fontSize: 8,
                              //           fontWeight: FontWeight.bold,
                              //           height: 1.0,
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
    );
  }
}
