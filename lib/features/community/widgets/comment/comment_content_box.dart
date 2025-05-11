import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/features/community/models/comment_model.dart';

class CommentContentBox extends StatefulWidget {
  final bool isDeleted;
  final bool isReply;
  final bool isEditing;
  final TextEditingController editingController;
  final VoidCallback onEditComplete;
  final VoidCallback onCancelEdit;
  final String commentContent;
  final List<CommentModel>? replies;
  final String? mentionUserId;

  const CommentContentBox({
    super.key,
    required this.isDeleted,
    required this.isReply,
    required this.isEditing,
    required this.editingController,
    required this.onEditComplete,
    required this.onCancelEdit,
    required this.commentContent,
    this.replies,
    this.mentionUserId,
  });

  @override
  State<CommentContentBox> createState() => _CommentContentBoxState();
}

class _CommentContentBoxState extends State<CommentContentBox> {
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    widget.editingController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    widget.editingController.removeListener(_updateButtonState);
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled =
          widget.editingController.text.trim().isNotEmpty == true &&
              (widget.editingController.text.trim() !=
                  widget.commentContent.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    TextSpan getFormattedContent(String content, String? mentionUserId) {
      if (mentionUserId == null || widget.replies == null) {
        return TextSpan(
            text: content, style: body_3.copyWith(color: AppColors.label));
      }

      // mentionUserId에 해당하는 댓글 찾기
      final mentionedUser = widget.replies!.firstWhere(
        (reply) => reply.userId == mentionUserId,
        orElse: () => CommentModel(
            isAuthor: false,
            id: '',
            userId: '',
            content: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            replies: []),
      );

      if (mentionedUser.anonymousId != null &&
          mentionedUser.anonymousId!.isNotEmpty) {
        return TextSpan(
          children: [
            TextSpan(
              text: '@${mentionedUser.anonymousId} ',
              style: subtitle_S.copyWith(color: AppColors.labelStrong),
            ),
            TextSpan(
              text: content,
              style: body_3.copyWith(color: AppColors.label),
            ),
          ],
        );
      }

      return TextSpan(
          text: content, style: body_3.copyWith(color: AppColors.label));
    }

    if (widget.isDeleted) {
      return Container(
        height: widget.isReply && widget.isDeleted ? 24 : 69,
        width: double.infinity,
        alignment: Alignment.centerLeft,
        padding: widget.isReply && widget.isDeleted
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 16),
        color: widget.isReply ? AppColors.backgroundAlternative : Colors.white,
        child: Text(
          "작성자에 의해 삭제된 댓글입니다.",
          style: body_3.copyWith(color: AppColors.labelAlternative),
        ),
      );
    } else if (widget.isEditing) {
      return Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 텍스트 입력 필드
              SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: widget.editingController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintStyle: body_2.copyWith(
                      color: AppColors.labelAssistive,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.line),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.line),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.line),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),

          /// 취소 & 완료 버튼
          Positioned(
            bottom: -18,
            right: -5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /// 취소 버튼
                TextButton(
                  onPressed: widget.onCancelEdit,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(40, 32),
                  ),
                  child: Text(
                    "취소",
                    style: body_3.copyWith(
                      color: AppColors.labelAlternative,
                      height: 1.0, // 텍스트가 정확히 중앙 정렬되도록 설정
                    ),
                  ),
                ),

                /// 완료 버튼
                TextButton(
                  onPressed: isButtonEnabled ? widget.onEditComplete : null,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(40, 32),
                  ),
                  child: Text(
                    "완료",
                    style: body_3.copyWith(
                      color: isButtonEnabled
                          ? AppColors.primary
                          : AppColors.labelAlternative,
                      height: 1.0, // 텍스트가 정확히 중앙 정렬되도록 설정
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Text.rich(
        getFormattedContent(widget.commentContent, widget.mentionUserId),
        style: body_3.copyWith(color: AppColors.label),
      );
    }
  }
}
