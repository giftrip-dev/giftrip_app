import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/enum/community_enum.dart';
import 'package:giftrip/core/utils/formatter.dart';
import 'package:giftrip/features/community/models/post_model.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/features/community/view_models/community_view_model.dart';
import 'package:giftrip/core/utils/amplitude_logger.dart';

class ContentBox extends StatelessWidget {
  final PostModel postData;

  const ContentBox({super.key, required this.postData});

  @override
  Widget build(BuildContext context) {
    final communityVM = context.watch<CommunityViewModel>();

    void toggleLike() {
      communityVM.toggleLike(context, postData.id, postData.isLiked ?? false);
      if (postData.isLiked == false) {
        AmplitudeLogger.logClickEvent(
          'like_toggle_active',
          'like_toggle',
          '${postData.id}_detail_screen',
        );
      } else {
        AmplitudeLogger.logClickEvent(
          'like_toggle_inactive',
          'like_toggle',
          '${postData.id}_detail_screen',
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Text(postData.title, style: title_L),
          const SizedBox(height: 4),

          // 카테고리, 날짜, 글쓴이
          Row(
            children: [
              Text(
                BeautyCategory.toKoreanString(postData.beautyCategory),
                style: caption.copyWith(color: AppColors.statusAlarm),
              ),
              const SizedBox(width: 4),
              Text('·',
                  style: caption.copyWith(color: AppColors.labelAlternative)),
              const SizedBox(width: 4),
              Text(
                DateUtil.formatTimeAgo(postData.createdAt),
                style: caption.copyWith(color: AppColors.labelAlternative),
              ),
              const SizedBox(width: 4),
              Text('·',
                  style: caption.copyWith(color: AppColors.labelAlternative)),
              const SizedBox(width: 4),
              Text('글쓴묭',
                  style: caption.copyWith(color: AppColors.labelAlternative)),
            ],
          ),
          const SizedBox(height: 16),

          // 본문 내용
          Text(postData.content,
              style: body_S.copyWith(color: AppColors.label)),

          // 이미지 리스트 (fileUrls이 있을 경우)
          if (postData.fileUrls.isNotEmpty) ...[
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: postData.fileUrls.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        postData.fileUrls[index],
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 16),

          // ✅ 좋아요, 댓글, 조회수
          Row(
            children: [
              // 좋아요 아이콘 & 개수
              GestureDetector(
                onTap: toggleLike,
                child: Icon(
                  postData.isLiked ?? false
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 18,
                  color: (postData.isLiked ?? false)
                      ? AppColors.primary
                      : AppColors.labelAlternative,
                ),
              ),
              const SizedBox(width: 4),
              Text(postData.likeCount.toString(),
                  style: body_S.copyWith(color: AppColors.labelAlternative)),

              const SizedBox(width: 16),

              // 댓글 아이콘 & 개수
              Icon(LucideIcons.messageCircle,
                  size: 18, color: AppColors.labelAlternative),
              const SizedBox(width: 4),
              Text(postData.commentCount.toString(),
                  style: body_S.copyWith(color: AppColors.labelAlternative)),

              // 조회수
              const Spacer(),
              Icon(LucideIcons.eye,
                  size: 18, color: AppColors.labelAlternative),
              const SizedBox(width: 4),
              Text(postData.viewCount.toString(),
                  style: body_S.copyWith(color: AppColors.labelAlternative)),
            ],
          ),
        ],
      ),
    );
  }
}
