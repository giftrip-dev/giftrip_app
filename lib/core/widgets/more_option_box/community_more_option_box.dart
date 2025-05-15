import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/utils/amplitude_logger.dart';
import 'package:giftrip/core/widgets/modal/two_button_modal.dart';
import 'package:giftrip/features/community/widgets/report/report_modal.dart';
import 'package:giftrip/features/user/repositories/user_repo.dart';
import 'package:giftrip/features/root/screens/root_screen.dart';

class CommunityMoreOptionBox extends StatelessWidget {
  final bool isAuthor; // 작성자 여부
  final String authorId; // 작성자 id
  final String targetId; // 대상 id
  final String targetType; // 대상 ("COMMENT" | "POST")
  final VoidCallback onClose; // 더보기 팝오버 닫기 핸들러
  final VoidCallback onDelete; // 삭제 핸들러
  final VoidCallback onUpdate; // 수정 핸들러

  const CommunityMoreOptionBox({
    super.key,
    required this.isAuthor,
    required this.authorId,
    required this.targetId,
    required this.targetType,
    required this.onClose,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isAuthor ? 111 : 147,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: isAuthor
            ? [
                _buildOptionItem(
                  icon: LucideIcons.penTool,
                  text: '수정하기',
                  onTap: () {
                    onClose();
                    onUpdate();
                    if (targetType == "POST") {
                      AmplitudeLogger.logClickEvent(
                        'post_update_click',
                        'post_update_button',
                        '${targetId}_detail_screen',
                      );
                    }
                  },
                  showDivider: true,
                ),
                _buildOptionItem(
                  icon: LucideIcons.trash2,
                  text: '삭제하기',
                  onTap: () {
                    onClose();
                    _showDeleteModal(context);
                  },
                  showDivider: false,
                ),
              ]
            : [
                _buildOptionItem(
                  icon: LucideIcons.siren,
                  text: '신고하기',
                  onTap: () {
                    onClose();
                    _showReportModal(context, targetId, targetType);
                  },
                  showDivider: false,
                ),
                _buildOptionItem(
                  icon: LucideIcons.ban,
                  text: '사용자 차단하기',
                  onTap: () {
                    onClose();
                    _showBlockUserModal(context);
                  },
                  showDivider: false,
                ),
              ],
      ),
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
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Text(
                  text,
                  style: body_S,
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
          title: '${targetType == "POST" ? "게시글" : "댓글"}을 삭제할까요?',
          desc: '삭제된 ${targetType == "POST" ? "게시글" : "댓글"}은 다시 불러올 수 없어요.',
          onConfirm: () {
            Navigator.of(context).pop(); // 모달 닫기
            onDelete(); // 삭제 핸들러 실행
            AmplitudeLogger.logClickEvent(
              'delete_${targetType == "POST" ? "post" : "comment"}_click',
              'delete_${targetType == "POST" ? "post" : "comment"}_button',
              '${targetId}_${targetType == "POST" ? "detail_screen" : "comment_box"}',
            );
          },
        );
      },
    );
  }

  // 신고 모달 띄우기
  void _showReportModal(
      BuildContext context, String targetId, String targetType) {
    showDialog(
      context: context,
      barrierDismissible: false, // 외부 터치로 닫히지 않도록 설정
      builder: (context) {
        return ReportModal(targetId: targetId, targetType: targetType);
      },
    );
  }

  void _showBlockUserModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return TwoButtonModal(
          title: '사용자 차단하기',
          desc: '해당 사용자의 모든 글을 보지 않으시겠어요?',
          onConfirm: () async {
            // 사용자 차단 요청
            await UserRepository().postBlockUser(authorId);
            Navigator.of(context).pop(); // 모달 닫기
            Navigator.of(context).pop(); // 모달 닫기
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const RootScreen(
                  selectedIndex: 1,
                ),
              ),
              (route) => false,
            );
          },
        );
      },
    );
  }
}
