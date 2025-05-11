import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/constants/app_colors.dart';

class MyPageBox extends StatelessWidget {
  final String title;
  final Map<String, Map<String, dynamic>> myPageInfo;

  const MyPageBox({
    Key? key,
    required this.title,
    required this.myPageInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: subtitle_L,
          ),
          ...myPageInfo.entries.map((entry) {
            return GestureDetector(
              onTap: entry.value['onTap'], // Row 전체 터치 가능
              behavior: HitTestBehavior.opaque, // 빈 공간도 터치 가능하도록 설정
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: body_M.copyWith(color: AppColors.label),
                    ),
                    Text(
                      entry.value['text'] as String? ?? '',
                      style: body_S.copyWith(color: AppColors.labelAlternative),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
