import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/widgets/modal/request_fail_modal.dart';
import 'package:myong/features/community/models/dto/comment_dto.dart';
import 'package:myong/features/community/view_models/comment_view_model.dart';
import 'package:provider/provider.dart';
import 'package:myong/core/utils/amplitude_logger.dart';

class CommentInputBox extends StatefulWidget {
  final String postId;
  final FocusNode focusNode;
  final String? parentId;
  final String? mentionUserId;
  final String? anonymousId;
  final VoidCallback onCancelReply;

  const CommentInputBox({
    super.key,
    required this.postId,
    required this.focusNode,
    this.parentId,
    this.mentionUserId,
    this.anonymousId,
    required this.onCancelReply,
  });

  @override
  State<CommentInputBox> createState() => _CommentInputBoxState();
}

class _CommentInputBoxState extends State<CommentInputBox> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _submitComment() async {
    if (_controller.text.trim().isEmpty) return;

    final commentData = CommentPostDto(
      content: _controller.text.trim(),
      parentId: widget.parentId,
      mentionUserId: widget.mentionUserId,
    );

    final isSuccess = await context
        .read<CommentViewModel>()
        .addComment(context, widget.postId, commentData);

    if (isSuccess) {
      if (commentData.parentId == null) {
        AmplitudeLogger.logClickEvent(
          'comment_submit',
          'comment_submit_button',
          '${widget.postId}_comment_input_box',
        );
      } else {
        AmplitudeLogger.logClickEvent(
          'reply_submit',
          'reply_submit_button',
          '${commentData.parentId}_comment_input_box',
        );
      }
      _controller.clear();
      widget.focusNode.unfocus();

      /// 댓글 작성 후 답글 모드 해제
      widget.onCancelReply();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return RequestFailModal(
            onConfirm: () => Navigator.of(context).pop(),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 42),
      child: Column(
        children: [
          if (widget.parentId != null && widget.anonymousId != null)
            Row(
              children: [
                Text(
                  "@${widget.anonymousId}님에게 작성 중",
                  style: subtitle_S.copyWith(color: AppColors.labelStrong),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: widget.onCancelReply,
                  child: const Icon(LucideIcons.x, size: 20),
                ),
              ],
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: widget.focusNode,
                  textAlignVertical: TextAlignVertical.center,
                  style: body_2,
                  decoration: InputDecoration(
                    hintText: widget.parentId == null
                        ? '게시글에 대한 나의 생각은 어떤가요?'
                        : '답글을 입력하세요...',
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
                        vertical: 12, horizontal: 24),
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(LucideIcons.arrowUpCircle, size: 40),
                onPressed: _submitComment,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
