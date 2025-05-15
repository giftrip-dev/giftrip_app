import 'dart:io';
import 'package:flutter/material.dart';
import 'package:giftrip/core/services/s3.dart';
import 'package:giftrip/features/community/screens/community_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:giftrip/core/widgets/modal/request_fail_modal.dart';
import 'package:giftrip/features/community/view_models/community_write_view_model.dart';
import 'package:giftrip/features/community/widgets/write_app_bar.dart';
import 'package:giftrip/features/community/widgets/title_input_field.dart';
import 'package:giftrip/features/community/widgets/content_input_field.dart';
import 'package:giftrip/features/community/widgets/guide_text_box.dart';
import 'package:giftrip/features/community/widgets/upload_image.dart';
import 'package:giftrip/core/enum/community_enum.dart';
import 'package:giftrip/features/community/models/post_model.dart';
import 'package:giftrip/core/utils/amplitude_logger.dart';

class EditScreen extends StatefulWidget {
  final PostModel post; // 기존 게시글 정보

  const EditScreen({
    super.key,
    required this.post,
  });

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  // 기존 이미지 URL (서버에 이미 저장되어 있는 것들)
  List<String> _existingUrls = [];

  // 새로 업로드할 로컬 이미지
  List<File> _newImages = [];

  // 선택된 카테고리
  late BeautyCategory _selectedCategory;

  bool _isSubmitting = false;
  bool _hasContent = false; // 새로운 상태 추가

  // 에러 메시지
  String? _titleError;
  String? _contentError;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post.title);
    _contentController = TextEditingController(text: widget.post.content);
    _selectedCategory = widget.post.beautyCategory;
    // 서버에 저장된 이미지 URL 들
    _existingUrls = List.from(widget.post.fileUrls ?? []);

    // 컨트롤러에 리스너 추가
    _titleController.addListener(_checkContent);
    _contentController.addListener(_checkContent);

    // 초기 상태 체크
    _checkContent();

    AmplitudeLogger.logViewEvent(
      "app_community_update_screen_view",
      "app_${widget.post.id}_update_screen",
    );
  }

  @override
  void dispose() {
    _titleController.removeListener(_checkContent);
    _contentController.removeListener(_checkContent);
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // 컨텐츠 상태 체크 함수
  void _checkContent() {
    setState(() {
      _hasContent = _titleController.text.isNotEmpty ||
          _contentController.text.isNotEmpty ||
          _newImages.isNotEmpty ||
          _existingUrls.isNotEmpty;
    });
  }

  // 글 수정 로직
  Future<void> _validateAndUpdate() async {
    setState(() {
      _titleError = _titleController.text.trim().isEmpty ? "제목을 입력해주세요." : null;
      _contentError =
          _contentController.text.trim().isEmpty ? "내용을 입력해주세요." : null;
    });

    // 필수 입력 검증 실패 시 종료
    if (_titleError != null || _contentError != null) return;

    setState(() => _isSubmitting = true); // 로딩 시작

    final writeViewModel =
        Provider.of<CommunityWriteViewModel>(context, listen: false);

    // updatePost 호출
    bool success = await writeViewModel.updatePost(
      postId: widget.post.id, // 기존 게시글 ID
      beautyCategory: _selectedCategory,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      domain: FileDomain.post,
      remainingUrls: _existingUrls, // 삭제되지 않고 남은 기존 이미지 URL
      localFilePaths: _newImages.map((file) => file.path).toList(),
    );

    setState(() => _isSubmitting = false); // 로딩 종료

    if (success) {
      // 수정 성공 시, 커뮤니티 상세 페이지로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CommunityDetailScreen(postId: widget.post.id),
          settings: RouteSettings(name: "/community/${widget.post.id}"),
        ),
      );
    } else {
      // 실패 모달 표시
      _showFailModal();
    }
  }

  void _showFailModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RequestFailModal(
          onConfirm: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: WriteAppBar(
          selectedCategory: _selectedCategory,
          onCategorySelected: (BeautyCategory newCategory) {
            setState(() {
              _selectedCategory = newCategory;
            });
          },
          onSubmit: _isSubmitting ? null : _validateAndUpdate,
          isSubmitting: _isSubmitting,
          hasContent: _hasContent, // 상태 변수 사용
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleInputField(
                  controller: _titleController,
                  errorText: _titleError,
                ),
                const SizedBox(height: 8),
                ContentInputField(
                  controller: _contentController,
                  placeholder: "내용을 입력해주세요.",
                  errorText: _contentError,
                  minLen: 1,
                  maxLen: 500,
                ),
                const SizedBox(height: 16),

                // 이미지 업로드 위젯
                UploadImageWidget(
                  parentContext: context,
                  existingUrls: _existingUrls,
                  newImages: _newImages,
                  onNewImageAdded: (file) {
                    setState(() {
                      _newImages.add(file);
                      _checkContent(); // 상태 업데이트
                    });
                  },
                  onNewImageRemoved: (index) {
                    setState(() {
                      _newImages.removeAt(index);
                      _checkContent(); // 상태 업데이트
                    });
                  },
                  onExistingUrlRemoved: (index) {
                    setState(() {
                      _existingUrls.removeAt(index);
                      _checkContent(); // 상태 업데이트
                    });
                  },
                ),
                const SizedBox(height: 24),
                const GuideTextBox(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
