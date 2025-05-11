import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myong/core/services/s3.dart';
import 'package:myong/features/community/widgets/guide_text_box.dart';
import 'package:myong/features/community/widgets/upload_image.dart';
import 'package:myong/features/root/screens/root_screen.dart';
import 'package:provider/provider.dart';
import 'package:myong/core/enum/community_enum.dart';
import 'package:myong/features/community/view_models/community_write_view_model.dart';
import 'package:myong/features/community/widgets/write_app_bar.dart';
import 'package:myong/features/community/widgets/title_input_field.dart';
import 'package:myong/features/community/widgets/content_input_field.dart';
import 'package:myong/core/widgets/modal/request_fail_modal.dart';
import 'package:myong/core/utils/logger.dart';
import 'package:myong/core/utils/amplitude_logger.dart';

class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  List<File> _uploadedImages = [];
  BeautyCategory _selectedCategory = BeautyCategory.free;
  bool _isSubmitting = false;
  bool _hasContent = false;

  // 에러 메시지 상태
  String? _titleError;
  String? _contentError;

  @override
  void initState() {
    super.initState();
    // 컨트롤러에 리스너 추가
    _titleController.addListener(_checkContent);
    _contentController.addListener(_checkContent);
    AmplitudeLogger.logViewEvent("app_write_screen_view", "app_write_screen");
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
          _uploadedImages.isNotEmpty;
    });
  }

  // 글 작성 핸들러
  Future<void> _validateAndSubmit() async {
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

    bool success = await writeViewModel.submitPost(
      beautyCategory: _selectedCategory,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      domain: FileDomain.post,
      localFilePaths: _uploadedImages.map((file) => file.path).toList(),
    );

    if (mounted) {
      setState(() => _isSubmitting = false); // 로딩 종료
    }

    if (success) {
      // 커뮤니티 스크린으로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const RootScreen(
            selectedIndex: 1,
          ),
        ),
      );
      AmplitudeLogger.logClickEvent(
        'post_submit_click',
        'post_submit_button',
        'write_screen',
      );
    } else {
      _showFailModal();
    }
  }

  // 실패 모달 호출
  void _showFailModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RequestFailModal(
          onConfirm: () => Navigator.of(context).pop(), // 확인 버튼 클릭 시 모달 닫기
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
          onSubmit: _isSubmitting ? null : _validateAndSubmit,
          isSubmitting: _isSubmitting,
          hasContent: _hasContent,
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

                  existingUrls: [], // 글 작성 화면에서는 기존 이미지 없음
                  newImages: _uploadedImages, // 새로 추가된 로컬 이미지 리스트
                  onNewImageAdded: (image) {
                    setState(() {
                      _uploadedImages.add(image);
                      _checkContent(); // 상태 업데이트
                    });
                  },
                  onNewImageRemoved: (index) {
                    setState(() {
                      _uploadedImages.removeAt(index);
                      _checkContent(); // 상태 업데이트
                    });
                  },
                  onExistingUrlRemoved: (index) {}, // 글 작성 화면에서는 사용되지 않음
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
