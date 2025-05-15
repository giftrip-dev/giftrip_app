import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/features/notification/models/notification_model.dart';
import 'package:giftrip/features/notification/view_models/notification_view_model.dart';
import 'package:giftrip/features/community/screens/community_detail_screen.dart';
import 'package:giftrip/core/utils/amplitude_logger.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final NotificationViewModel viewModel;

  NotificationItem({required this.notification, required this.viewModel});

  String _formatTime(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return '방금 전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 전';
    } else {
      return '${difference.inDays}일 전';
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData iconData;

    switch (notification.action) {
      case 'POST_LIKED':
      case 'COMMENT_CREATED':
      case 'COMMENT_REPLIED':
        iconData = LucideIcons.coffee;
        break;
      case 'POST_HIDDEN':
      case 'COMMENT_HIDDEN':
        iconData = LucideIcons.siren;
        break;
      case 'CERTIFICATE_APPROVED':
      case 'CERTIFICATE_REJECTED':
        iconData = LucideIcons.shieldAlert;
        break;
      case 'NOTICE':
      case 'COUPON_ISSUED':
        iconData = LucideIcons.lightbulb;
        break;
      default:
        iconData = LucideIcons.info;
    }

    return Slidable(
      key: ValueKey(notification.id),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            padding: EdgeInsets.zero,
            onPressed: (context) {
              viewModel.deleteNotification(id: notification.id);
              AmplitudeLogger.logClickEvent(
                'notification_delete_click',
                'notification_delete_button',
                'notification_screen',
              );
            },
            backgroundColor: AppColors.statusError,
            icon: LucideIcons.trash2,
            flex: 1,
          ),
        ],
        extentRatio: 0.2,
      ),
      child: Container(
        child: GestureDetector(
          onTap: () {
            if (notification.action == 'POST_LIKED' ||
                notification.action == 'COMMENT_CREATED' ||
                notification.action == 'COMMENT_REPLIED') {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      CommunityDetailScreen(postId: notification.targetId),
                ),
              );
              AmplitudeLogger.logClickEvent(
                'notification_item_click',
                'notification_item',
                'notification_screen',
              );
            }
            viewModel.readNotification(id: notification.id);
          },
          child: Container(
            decoration: BoxDecoration(
              color: notification.isRead
                  ? AppColors.background
                  : const Color(0xFFFFF4F6),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(notification.body,
                  style: subtitle_S.copyWith(color: AppColors.labelStrong)),
              subtitle: Text(_formatTime(notification.createdAt),
                  style: caption.copyWith(color: AppColors.labelNatural)),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.background,
                  border: Border.all(color: AppColors.line, width: 1),
                ),
                child: Icon(iconData, color: AppColors.labelStrong),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
