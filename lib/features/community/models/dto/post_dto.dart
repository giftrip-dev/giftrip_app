import 'package:myong/core/enum/community_enum.dart';

// 게시글 작성 DTO
class PostCreateRequestDto {
  final BeautyCategory beautyCategory;
  final String title;
  final String content;
  final List<String> fileUrls;

  PostCreateRequestDto({
    required this.beautyCategory,
    required this.title,
    required this.content,
    required this.fileUrls,
  });

  Map<String, dynamic> toJson() {
    return {
      'beautyCategory': BeautyCategory.toUpperString(beautyCategory),
      'title': title,
      'content': content,
      'fileUrls': fileUrls,
    };
  }
}
