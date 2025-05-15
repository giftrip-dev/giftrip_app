import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/enum/community_enum.dart';
import 'package:giftrip/core/utils/formatter.dart';
import 'package:giftrip/features/community/models/post_model.dart';
import 'package:giftrip/features/community/screens/community_detail_screen.dart';
import 'package:giftrip/core/utils/amplitude_logger.dart';

class PostItem extends StatelessWidget {
  final PostModel post;
  final String viewName;

  const PostItem({
    super.key,
    required this.post,
    required this.viewName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AmplitudeLogger.logClickEvent(
            "post_detail_click", "post_item", viewName);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommunityDetailScreen(postId: post.id),
            settings: RouteSettings(name: "/community/${post.id}"),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.line,
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 첫 번째 박스 (Title & Content & Image)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title & Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: subtitle_M,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        post.content,
                        style: caption.copyWith(color: AppColors.label),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // 이미지
                if (post.thumbnailUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        post.thumbnailUrl ?? "",
                        width: 46,
                        height: 46,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12.5),

            // 두 번째 박스 (Category · Date · Likes · Comments)
            Row(
              children: [
                // Category
                Text(
                  BeautyCategory.toKoreanString(post.beautyCategory),
                  style: caption.copyWith(color: AppColors.statusAlarm),
                ),
                const SizedBox(width: 4),

                // Date
                Text('·',
                    style: caption.copyWith(color: AppColors.labelAlternative)),
                SizedBox(width: 4),
                Text(
                  DateUtil.formatTimeAgo(post.createdAt),
                  style: caption.copyWith(color: AppColors.labelAlternative),
                ),
                const Spacer(),

                // Likes
                Icon(LucideIcons.heart,
                    size: 14, color: AppColors.labelAlternative),
                const SizedBox(width: 4),
                Text(
                  '${post.likeCount}',
                  style: caption.copyWith(color: AppColors.labelAlternative),
                ),

                // Comments
                const SizedBox(width: 8),
                Icon(LucideIcons.messageCircle,
                    size: 14, color: AppColors.labelAlternative),
                const SizedBox(width: 4),
                Text(
                  '${post.commentCount}',
                  style: caption.copyWith(color: AppColors.labelAlternative),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
