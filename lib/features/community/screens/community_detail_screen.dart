import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/widgets/modal/one_button_modal.dart';
import 'package:myong/features/community/view_models/comment_view_model.dart';
import 'package:myong/features/community/view_models/community_view_model.dart';
import 'package:myong/features/community/widgets/comment/comment_box.dart';
import 'package:myong/features/community/widgets/comment/comment_input_box.dart';
import 'package:myong/features/community/widgets/community_app_bar.dart';
import 'package:myong/features/community/widgets/content_box.dart';
import 'package:provider/provider.dart';
import 'package:myong/core/utils/amplitude_logger.dart';

class CommunityDetailScreen extends StatefulWidget {
  final String postId;
  const CommunityDetailScreen({super.key, required this.postId});

  @override
  State<CommunityDetailScreen> createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();

  /// 답글 작성 시 필요한 상태
  String? parentId;
  String? mentionUserId;
  String? anonymousId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final communityVM = context.read<CommunityViewModel>();
      final commentVM = context.read<CommentViewModel>();

      // 게시글 상세 & 댓글 목록 조회
      communityVM.fetchPostDetail(widget.postId);
      commentVM.fetchComments(widget.postId);
      AmplitudeLogger.logViewEvent("app_community_detail_screen_view",
          "app_${widget.postId}_detail_screen");
    });
  }

  /// 게시글 삭제 핸들러
  void _handleDeletePost() async {
    final communityVM = context.read<CommunityViewModel>();
    final result = await communityVM.deletePost(context, widget.postId);

    if (result && context.mounted == true) {
      showDialog(
        context: context,
        barrierDismissible: false, // 모달 바깥 클릭으로 닫히지 않도록 설정
        builder: (context) {
          return OneButtonModal(
            title: '게시글 삭제 성공',
            desc: '게시글이 삭제되었어요.',
            onConfirm: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final communityVM = context.watch<CommunityViewModel>();
    final commentVM = context.watch<CommentViewModel>();

    if (communityVM.isDetailLoading || commentVM.isLoading(widget.postId)) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final postData = communityVM.selectedPost;
    final comments = commentVM.getComments(widget.postId);

    if (postData == null) {
      return const Scaffold(
        body: Center(child: Text('데이터를 불러오지 못했습니다.')),
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 화면 바깥을 누르면 키보드 닫기
      },
      child: Scaffold(
        appBar: CommunityAppBar(
          post: postData,
          postId: postData.id,
          isAuthor: postData.isAuthor ?? false,
          authorId: postData.authorId ?? '',
          onDelete: _handleDeletePost,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ContentBox(postData: postData),
                        const SizedBox(height: 16),
                        const Divider(
                          color: AppColors.line,
                          height: 1,
                        ),
                        if (comments.isEmpty)
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Center(
                              child: Text(
                                '첫 번째 댓글을 남겨보세요',
                                style: body_M.copyWith(
                                    color: AppColors.labelAssistive),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        else
                          Column(
                            children: comments
                                .map((comment) => CommentBox(
                                    postId: postData.id,
                                    authorId: postData.authorId,
                                    userId: comment.userId,
                                    replies: comment.replies,
                                    isOriginalComment: true,
                                    comment: comment,
                                    onReply: (String parent, String? mention,
                                        String? anonymous) {
                                      setState(() {
                                        parentId = parent;
                                        mentionUserId = mention;
                                        anonymousId = anonymous;
                                      });

                                      /// 답글 작성 시, 입력창 포커스
                                      _inputFocusNode.requestFocus();
                                    }))
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                ),

                /// 댓글 입력 박스
                CommentInputBox(
                  postId: widget.postId,
                  focusNode: _inputFocusNode,
                  parentId: parentId,
                  mentionUserId: mentionUserId,
                  anonymousId: anonymousId,
                  onCancelReply: () {
                    setState(() {
                      parentId = null;
                      mentionUserId = null;
                      anonymousId = null;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
