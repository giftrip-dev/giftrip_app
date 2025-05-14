import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';

/// 상품 문의하기 및 변경/취소 정보 섹션 위젯
class ProductPolicySection extends StatelessWidget {
  final String title; // 섹션 제목 (예: '문의하기', '변경 및 취소')
  final String sectionTitle; // 내용 제목
  final String sectionContent; // 내용 설명

  const ProductPolicySection({
    required this.title,
    required this.sectionTitle,
    required this.sectionContent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final contentWidth = deviceWidth - 32; // 패딩 고려한 실제 컨텐츠 너비

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 제목
          Text(title, style: title_L),

          const SizedBox(height: 16),

          // 내용 컨테이너
          Container(
            width: contentWidth,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.backgroundAlternative,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 내용 제목
                Text(
                  sectionTitle,
                  style: subtitle_M,
                ),

                const SizedBox(height: 12),

                // 내용 설명 (줄바꿈 반영, 단어 분리)
                PreservingWhiteSpaceText(
                  sectionContent,
                  style: body_S.copyWith(
                    color: AppColors.label,
                    height: 1.5, // 줄 간격 조정
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 줄바꿈과 공백을 보존하는 텍스트 위젯 (white-space: pre-line과 유사한 기능)
class PreservingWhiteSpaceText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;

  const PreservingWhiteSpaceText(
    this.text, {
    this.style,
    this.textAlign = TextAlign.left,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // 텍스트 줄을 분리
    final lines = text.split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        return Text(
          line,
          style: style,
          textAlign: textAlign,
          softWrap: true,
          overflow: TextOverflow.visible,
          textWidthBasis: TextWidthBasis.longestLine,
        );
      }).toList(),
    );
  }
}
