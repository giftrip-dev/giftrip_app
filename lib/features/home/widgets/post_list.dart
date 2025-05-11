import 'package:flutter/material.dart';
import 'package:myong/features/community/models/post_model.dart';
import 'package:myong/features/community/widgets/post_item.dart';

class PostListWidget extends StatelessWidget {
  final List<PostModel> posts;
  final String viewName;
  const PostListWidget({
    super.key,
    required this.posts,
    required this.viewName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          posts.length,
          (index) => PostItem(
            post: posts[index],
            viewName: viewName,
          ),
        ));
  }
}
