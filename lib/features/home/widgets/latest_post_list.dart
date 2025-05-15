import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/features/community/models/post_model.dart';
import 'package:giftrip/features/home/widgets/board_header.dart';
import 'package:giftrip/features/home/widgets/post_list.dart';
import 'package:giftrip/features/root/screens/root_screen.dart';
import 'package:giftrip/core/utils/amplitude_logger.dart';

class LatestPostListWidget extends StatelessWidget {
  final List<PostModel> posts;

  const LatestPostListWidget({
    super.key,
    required this.posts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 게시판 헤더
        BoardHeaderWidget(
          title: '👀 방금 올라온 게시글',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RootScreen(
                  selectedIndex: 1,
                ),
              ),
            );
            AmplitudeLogger.logClickEvent("latest_post_see_more_click",
                "latest_post_see_more_button", "home_screen");
          },
        ),
        const SizedBox(height: 8),

        // 게시글 없는 경우
        if (posts.isEmpty)
          Container(
            height: 402,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.backgroundNatural,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '아직 인기글이 없어요\n첫 게시글의 주인공이 되어보세요!',
              style: subtitle_S.copyWith(color: AppColors.labelNatural),
              textAlign: TextAlign.center,
            ),
          )
        else
          // 최신 게시글 리스트
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.line,
                  width: 1,
                ),
              ),
              child: PostListWidget(
                posts: posts,
                viewName: "latest_post_list",
              ))
      ],
    );
  }
}
