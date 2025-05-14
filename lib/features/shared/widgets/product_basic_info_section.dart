import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/widgets/image/custom_image.dart';
import 'package:myong/features/home/models/product_model.dart';
import 'package:myong/features/home/widgets/product/item_badge.dart';

/// 상품 상세 정보 섹션 위젯
class ProductBasicInfoSection extends StatelessWidget {
  final String title;
  final String thumbnailUrl;
  final List<ItemBadgeType> badges;
  final String location;
  final String? memo;
  final String phoneNumber;
  final String? relatedLink;

  const ProductBasicInfoSection({
    required this.title,
    required this.thumbnailUrl,
    required this.badges,
    required this.location,
    required this.phoneNumber,
    this.memo,
    this.relatedLink,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 썸네일 이미지 (정사각형, 디바이스 너비만큼)
        CustomImage(
          imageUrl: thumbnailUrl,
          width: deviceWidth,
          height: deviceWidth,
          fit: BoxFit.cover,
        ),

        // 상품 정보 컨테이너
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상품 제목
              Text(title, style: title_L),

              // 뱃지들 (NEW, BEST 등)
              if (badges.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children:
                        badges.map((badge) => ItemBadge(type: badge)).toList(),
                  ),
                ),

              const SizedBox(height: 16),

              // 위치 정보
              _buildInfoRow(
                icon: LucideIcons.mapPin,
                text: location,
              ),

              // 메모 정보 (항상 표시, 없으면 "-"로 표시)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: _buildInfoRow(
                  icon: LucideIcons.pin,
                  text: memo?.isNotEmpty == true ? memo! : "-",
                ),
              ),

              // 전화번호
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: _buildInfoRow(
                  icon: LucideIcons.phone,
                  text: phoneNumber,
                  onTap: () => _makePhoneCall(phoneNumber),
                ),
              ),

              // 관련 링크 (선택적)
              if (relatedLink != null && relatedLink!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: _buildInfoRow(
                    icon: LucideIcons.link2,
                    text: relatedLink!,
                    isLink: true,
                    onTap: () => _launchURL(relatedLink!),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// 정보 행 위젯 생성 (아이콘 + 텍스트)
  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    bool isLink = false,
    VoidCallback? onTap,
  }) {
    final textWidget = Text(
      text,
      style: body_S.copyWith(
        color: AppColors.label,
        decoration: isLink ? TextDecoration.underline : null,
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 아이콘
        Padding(
          padding: const EdgeInsets.only(top: 3), // 아이콘을 약간 아래로 내려 텍스트와 정렬
          child: Icon(
            icon,
            size: 18,
            color: AppColors.label,
          ),
        ),
        const SizedBox(width: 8),

        // 텍스트
        Expanded(
          child: onTap != null
              ? GestureDetector(
                  onTap: onTap,
                  child: textWidget,
                )
              : textWidget,
        ),
      ],
    );
  }

  /// 전화 걸기
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    }
  }

  /// URL 열기
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
