import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';

class PermissionGuideModal extends StatelessWidget {
  final VoidCallback onConfirm;

  const PermissionGuideModal({
    Key? key,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '권한 요청',
              style: subtitle_L,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPermissionItem(
                  icon: Icons.notifications,
                  title: '알림',
                  description: '소식 및 게시글에 대한 알림을 받을 수 있습니다.',
                ),
                const SizedBox(height: 12),
                _buildPermissionItem(
                  icon: Icons.photo_library,
                  title: '앨범',
                  description: '앨범은 리뷰 작성에 사용됩니다.',
                ),
                const SizedBox(height: 12),
                _buildPermissionItem(
                  icon: Icons.camera_alt,
                  title: '카메라',
                  description: '카메라는 리뷰 작성에 사용됩니다.',
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: onConfirm,
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '확인',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: subtitle_S,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: body_S,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
