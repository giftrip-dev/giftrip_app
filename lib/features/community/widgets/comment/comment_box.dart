import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/utils/date_formatter.dart';
import 'package:myong/core/utils/amplitude_logger.dart';
import 'package:myong/features/community/models/comment_model.dart';
import 'package:myong/core/widgets/more_option_box/community_more_option_overlay_button.dart';
import 'package:myong/features/community/models/dto/comment_dto.dart';
import 'package:myong/features/community/view_models/comment_view_model.dart';
import 'package:myong/features/community/widgets/comment/comment_content_box.dart';
import 'package:provider/provider.dart';

class CommentBox extends StatefulWidget {
  final CommentModel comment;
  final bool isOriginalComment;
  final List<CommentModel>? replies;
  final Function(String parentId, String? mentionUserId, String? anonymous)
      onReply;
  final String? userId;
  final String? authorId;
  final String postId;

  const CommentBox({
    super.key,
    required this.comment,
    required this.onReply,
    required this.isOriginalComment,
    required this.postId,
    this.replies,
    this.userId,
    this.authorId,
  });

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  bool isEditing = false;
  late TextEditingController _editingController;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: widget.comment.content);
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  // 댓글 수정 핸들러
  void _handleEditComplete(BuildContext context) async {
    if (_editingController.text.trim().isEmpty) return;

    final commentVM = context.read<CommentViewModel>();

    // `parentId`와 `mentionUserId`가 있으면 포함
    final updatedComment = CommentUpdateDto(
      content: _editingController.text.trim(),
      parentId: widget.comment.parentId,
      mentionUserId: widget.comment.mentionUserId,
    );

    final success = await commentVM.updateComment(
      context,
      widget.postId,
      widget.comment.id,
      updatedComment,
    );

    if (success) {
      AmplitudeLogger.logClickEvent(
        'comment_update_click',
        'comment_update_button',
        '${widget.comment.id}_comment_box',
      );
      setState(() {
        isEditing = false;
      });
    }
  }

  void _cancelEdit() {
    setState(() {
      isEditing = false;
      _editingController.text = widget.comment.content;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isReply = widget.comment.parentId != null;
    final isAuthor = widget.userId == widget.authorId;
    final bool isDeleted = widget.comment.deletedAt != null;

    return Column(
      children: [
        Container(
          color: isReply ? AppColors.backgroundAlternative : Colors.transparent,
          child: Padding(
            padding: isDeleted
                ? isReply
                    ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
                    : EdgeInsets.zero
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isReply)
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(LucideIcons.cornerDownRight, size: 18),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isDeleted) ...[
                        Row(
                          children: [
                            Text(
                              widget.comment.anonymousId ?? "(정보없음)",
                              style: title_S,
                            ),
                            if (isAuthor)
                              Text(
                                ' (작성자)',
                                style:
                                    title_S.copyWith(color: AppColors.primary),
                              ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 0),
                              child: CommunityMoreOptionOverlayButton(
                                isAuthor: widget.comment.isAuthor,
                                authorId: widget.comment.userId,
                                targetId: widget.comment.id,
                                targetType: "COMMENT",
                                onDelete: () {
                                  context
                                      .read<CommentViewModel>()
                                      .deleteComment(context, widget.postId,
                                          widget.comment.id);
                                },
                                onUpdate: () {
                                  setState(() {
                                    isEditing = true;
                                  });
                                },
                                icon: LucideIcons.moreVertical,
                                iconSize: 18,
                                iconColor: AppColors.labelAlternative,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateUtil.formatTimeAgo(widget.comment.createdAt),
                          style: caption.copyWith(
                            color: AppColors.labelAlternative,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],

                      // 댓글 내용
                      CommentContentBox(
                          isDeleted: isDeleted,
                          isReply: isReply,
                          isEditing: isEditing,
                          editingController: _editingController,
                          onEditComplete: () => _handleEditComplete(context),
                          onCancelEdit: _cancelEdit,
                          commentContent: widget.comment.content,
                          replies: widget.replies,
                          mentionUserId: widget.comment.mentionUserId),

                      if (!isDeleted) const SizedBox(height: 8),
                      if (!isDeleted && !isEditing)
                        GestureDetector(
                          onTap: () {
                            widget.onReply(
                              widget.comment.parentId ?? widget.comment.id,
                              widget.isOriginalComment
                                  ? null
                                  : widget.comment.userId,
                              widget.comment.anonymousId,
                            );
                          },
                          child: Text(
                            "답글 작성하기   >",
                            style: title_XS.copyWith(
                              color: AppColors.labelStrong,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.comment.replies.isNotEmpty)
          Column(
            children: widget.comment.replies.map((reply) {
              return CommentBox(
                postId: widget.postId,
                authorId: widget.authorId,
                userId: reply.userId,
                replies: widget.replies,
                isOriginalComment: false,
                comment: reply,
                onReply: widget.onReply,
              );
            }).toList(),
          ),
        if (widget.comment.replies.isEmpty)
          const Divider(
            color: AppColors.line,
            height: 1,
          ),
      ],
    );
  }
}
