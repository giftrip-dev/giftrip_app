import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/utils/amplitude_logger.dart';
import 'package:myong/core/widgets/modal/two_button_modal.dart';
import 'package:myong/features/community/widgets/report/report_modal.dart';
import 'package:myong/features/user/repositories/user_repo.dart';
import 'package:myong/features/root/screens/root_screen.dart';

class NotificationMoreOptionBox extends StatelessWidget {
  final String targetType; // 대상 ("COMMENT" | "POST")
  final VoidCallback onClose; // 더보기 팝오버 닫기 핸들러
  final VoidCallback onDeleteAll; // 삭제 핸들러
  final VoidCallback onReadAll; // 수정 핸들러

  const NotificationMoreOptionBox({
    super.key,
    required this.targetType,
    required this.onClose,
    required this.onDeleteAll,
    required this.onReadAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 147,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        _buildOptionItem(
          icon: LucideIcons.checkCircle,
          text: '전체 읽기',
          onTap: () {
            onClose();
            onReadAll();
            AmplitudeLogger.logClickEvent(
              'notification_read_all_click',
              'notification_read_all_button',
              'notification_screen',
            );
          },
          showDivider: true,
        ),
        _buildOptionItem(
          icon: LucideIcons.trash2,
          text: '전체 삭제',
          onTap: () {
            onClose();
            _showDeleteModal(context);
          },
          showDivider: false,
        ),
      ]),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required bool showDivider,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Text(
                  text,
                  style: body_3,
                ),
                const Spacer(),
                Icon(icon, size: 18),
              ],
            ),
          ),
        ),
        if (showDivider)
          Container(
            height: 1,
            color: AppColors.line,
          ),
      ],
    );
  }

  /// 삭제 확인 모달 띄우기
  void _showDeleteModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 배경 클릭으로 모달 닫기 방지
      builder: (context) {
        return TwoButtonModal(
          title: '모든 알림을 삭제할까요?',
          desc: '삭제된 알림은 다시 불러올 수 없어요.',
          onConfirm: () {
            Navigator.of(context).pop(); // 모달 닫기
            onDeleteAll(); // 삭제 핸들러 실행
            AmplitudeLogger.logClickEvent(
              'delete_all_notification_click',
              'delete_all_notification_button',
              'notification_screen',
            );
          },
        );
      },
    );
  }
}
