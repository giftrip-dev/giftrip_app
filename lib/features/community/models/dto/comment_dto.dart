// 댓글 작성 DTO
class CommentPostDto {
  final String content;
  final String? parentId;
  final String? mentionUserId;

  CommentPostDto({
    required this.content,
    this.parentId,
    this.mentionUserId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'content': content,
    };

    if (parentId != null) data['parentId'] = parentId;
    if (mentionUserId != null) data['mentionUserId'] = mentionUserId;

    return data;
  }
}

class CommentUpdateDto {
  final String content;
  final String? parentId;
  final String? mentionUserId;

  CommentUpdateDto({
    required this.content,
    this.parentId,
    this.mentionUserId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'content': content,
    };

    if (parentId != null) data['parentId'] = parentId;
    if (mentionUserId != null) data['mentionUserId'] = mentionUserId;

    return data;
  }
}
