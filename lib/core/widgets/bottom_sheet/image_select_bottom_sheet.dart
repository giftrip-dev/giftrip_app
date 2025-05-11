import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/widgets/modal/one_button_modal.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  final Function(ImageSource) onPickImage;

  const ImagePickerBottomSheet({Key? key, required this.onPickImage})
      : super(key: key);

  Future<void> _handleCameraSelection(BuildContext context) async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      onPickImage(ImageSource.camera);
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop(); // 바텀시트 닫기
      _showPermissionDeniedDialog(context);
    }
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => OneButtonModal(
        title: "카메라 권한이 필요합니다.\n설정에서 카메라 권한을 허용해주세요.",
        onConfirm: () {
          openAppSettings();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.only(bottom: 60),
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text(
              "앨범에서 선택",
              style: body_M,
            ),
            onTap: () async {
              onPickImage(ImageSource.gallery);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text(
              "카메라로 촬영",
              style: body_M,
            ),
            onTap: () => _handleCameraSelection(context),
          ),
        ],
      ),
    );
  }
}
