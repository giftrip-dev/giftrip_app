import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/widgets/bottom_sheet/image_select_bottom_sheet.dart';
import 'package:myong/core/widgets/modal/one_button_modal.dart';

class UploadImageWidget extends StatefulWidget {
  /// 부모(WriteScreen)의 BuildContext를 전달받아서
  /// showDialog / showModalBottomSheet 시에 사용
  final BuildContext parentContext;

  /// 새로 추가된 로컬 이미지들
  final List<File> newImages;

  /// 이미 서버에 올라가 있는 기존 이미지의 URL 목록
  final List<String> existingUrls;

  /// 새 로컬 이미지를 추가할 때 호출되는 콜백
  final Function(File) onNewImageAdded;

  /// 새 로컬 이미지를 제거할 때 호출되는 콜백
  final Function(int) onNewImageRemoved;

  /// 기존 URL 이미지를 제거할 때 호출되는 콜백
  final Function(int) onExistingUrlRemoved;

  const UploadImageWidget({
    super.key,
    required this.parentContext,
    required this.newImages,
    required this.existingUrls,
    required this.onNewImageAdded,
    required this.onNewImageRemoved,
    required this.onExistingUrlRemoved,
  });

  @override
  State<UploadImageWidget> createState() => _UploadImageWidgetState();
}

class _UploadImageWidgetState extends State<UploadImageWidget> {
  final ImagePicker _picker = ImagePicker();

  // 이미지 선택(갤러리/카메라) 핸들러
  Future<void> _handleImagePick(
    BuildContext context, // 이건 bottomSheet 내부 context
    ImageSource source,
  ) async {
    if (widget.existingUrls.length + widget.newImages.length >= 5) return;

    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      final imageFile = File(image.path);
      final fileSize = await imageFile.length();

      // 25MB 초과 시
      if (fileSize > 25 * 1024 * 1024) {
        // bottomSheet가 열려있는 경우라면 미리 pop()으로 닫아도 된다
        // Navigator.of(context).pop(); // bottomSheet 닫기 (원하면 사용)

        // parentContext(=WriteScreen의 context)에서 모달을 띄운다
        if (mounted) {
          _showSizeWarningModal(widget.parentContext);
        }
      } else {
        // 정상 크기면 이미지 추가
        widget.onNewImageAdded(imageFile);
      }
    }
  }

  // 이미지 선택 모달 (여기서도 parentContext 사용 가능)
  void _showImagePickerModal(BuildContext context) {
    // (기존 + 신규) 합쳐서 5장 초과면 업로드 불가
    if (widget.existingUrls.length + widget.newImages.length >= 5) {
      _showMaxImageWarningModal(widget.parentContext);
      return;
    }

    // bottomSheet는 여기서 'context' 그대로 사용해도 되고
    // 만약 호환성 문제가 생기면 parentContext 사용 가능
    showModalBottomSheet(
      context: widget.parentContext, // parentContext 사용 (안전)
      builder: (BuildContext bc) {
        return ImagePickerBottomSheet(
          onPickImage: (source) => _handleImagePick(bc, source),
        );
      },
    );
  }

  /// 25MB 초과 시 경고 모달
  void _showSizeWarningModal(BuildContext parentCtx) {
    showDialog(
      context: parentCtx,
      builder: (ctx) {
        return OneButtonModal(
          title: "크기가 25MB 이하인 이미지를\n등록해주세요.",
          onConfirm: () {
            Navigator.of(ctx).pop(); // 모달 닫기
          },
        );
      },
    );
  }

  /// 업로드 제한 (최대 5개) 경고 모달
  void _showMaxImageWarningModal(BuildContext parentCtx) {
    showDialog(
      context: parentCtx,
      builder: (ctx) {
        return OneButtonModal(
          title: "이미지는 최대 5개까지\n올릴 수 있어요.",
          onConfirm: () {
            Navigator.of(ctx).pop(); // 모달 닫기
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // (기존 + 신규) 합쳐서 최대 5장
    final int totalCount = widget.existingUrls.length + widget.newImages.length;
    final bool isMaxImages = totalCount >= 5;

    return SizedBox(
      height: 100, // 업로드 버튼과 이미지들이 한 줄에 배치되도록 유지
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // 업로드 버튼
          GestureDetector(
            onTap: () => _showImagePickerModal(context),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.lineStrong),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    LucideIcons.imagePlus,
                    size: 24,
                    color: AppColors.label,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$totalCount/5",
                    style: body_S.copyWith(
                      color:
                          isMaxImages ? AppColors.statusError : AppColors.label,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // (1) 기존 이미지들 (NetworkImage)
          ...List.generate(widget.existingUrls.length, (index) {
            final url = widget.existingUrls[index];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(url),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // 삭제 버튼 (오른쪽 상단)
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () {
                        widget.onExistingUrlRemoved(index);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black45,
                        ),
                        child: const Icon(
                          LucideIcons.xCircle,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          // (2) 새로 추가된 로컬 이미지들 (FileImage)
          ...List.generate(widget.newImages.length, (index) {
            final file = widget.newImages[index];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: FileImage(file),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () {
                        widget.onNewImageRemoved(index);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black45,
                        ),
                        child: const Icon(
                          LucideIcons.xCircle,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
