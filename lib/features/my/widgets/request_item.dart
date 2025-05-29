import 'package:flutter/material.dart';
import 'package:giftrip/features/my/models/request_model.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:intl/intl.dart';

class RequestItem extends StatelessWidget {
  final RequestModel request;

  const RequestItem({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yy.MM.dd');

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 날짜 & 상세보기
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateFormat.format(DateTime.parse(request.date)),
                    style: subtitle_M.copyWith(
                      color: AppColors.gray800,
                    ),
                  ),
                  Text(
                    '상세보기',
                    style: caption.copyWith(
                      color: AppColors.labelNatural,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // 이미지 + 정보
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImage(request.imageUrl),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.name,
                          style: body_M.copyWith(
                            color: AppColors.labelStrong,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${request.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}원',
                          style: title_M.copyWith(
                            color: AppColors.labelStrong,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red[200],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            request.status.label,
                            style: subtitle_XS.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(
            height: 1,
            thickness: 1,
            indent: 0,
            endIndent: 0,
            color: AppColors.line),
      ],
    );
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child:
            Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
      );
    } else {
      final assetPath = imageUrl.replaceFirst('file://', '');
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.asset(assetPath, width: 60, height: 60, fit: BoxFit.cover),
      );
    }
  }
}
