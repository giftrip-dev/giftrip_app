import 'package:giftrip/core/utils/route_observer.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giftrip/core/widgets/more_option_box/community_more_option_overlay_button.dart';
import 'package:giftrip/features/community/models/post_model.dart';
import 'package:giftrip/features/community/screens/update_screen.dart';
import 'package:giftrip/features/root/screens/root_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:giftrip/core/utils/amplitude_logger.dart';

class CommunityAppBar extends StatelessWidget implements PreferredSizeWidget {
  final PostModel post;
  final String postId;
  final bool isAuthor;
  final String authorId;
  final VoidCallback onDelete;
  final String? shareText;

  const CommunityAppBar({
    super.key,
    required this.post,
    required this.postId,
    required this.isAuthor,
    required this.authorId,
    required this.onDelete,
    this.shareText,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  void _shareContent() {
    String deepLink = "myong://community/$postId";
    Share.share("[오늘묭해] 이 게시글을 확인해보세요!\n$deepLink");
    AmplitudeLogger.logClickEvent(
        "post_share_click", "post_share_button", "${postId}_detail_screen");
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      leading: Padding(
        padding: const EdgeInsets.all(16),
        child: GestureDetector(
          onTap: () {
            final previousRoute = routeObserver.previousRoute ?? "";

            // 이전 페이지가 상세 페이지인지 확인
            final wasCommunityDetail =
                RegExp(r"^/community/[\w-]+$").hasMatch(previousRoute);

            if (wasCommunityDetail) {
              // 리스트 페이지로 이동
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => const RootScreen(
                          selectedIndex: 1,
                        )),
                (route) => false, // 기존 스택을 모두 제거
              );
            } else {
              // 뒤로 가기
              Navigator.pop(context);
            }
          },
          child: const Icon(
            LucideIcons.chevronLeft,
            size: 24,
            color: Colors.black,
          ),
        ),
      ),
      actions: [
        // 공유 아이콘
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: GestureDetector(
            onTap: _shareContent,
            child: const Icon(
              LucideIcons.share2,
              size: 24,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 12),

        // 더보기 팝오버 아이콘
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CommunityMoreOptionOverlayButton(
              isAuthor: isAuthor,
              authorId: authorId,
              targetId: postId,
              targetType: "POST",
              onDelete: onDelete,
              onUpdate: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditScreen(post: post),
                      ),
                    )
                  }),
        ),
      ],
    );
  }
}
