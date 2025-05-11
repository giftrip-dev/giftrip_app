import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myong/core/constants/app_text_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isBackButton; // 뒤로가기 여부
  final String? title; // 타이틀
  final Widget? rightWidget; // 오른쪽 버튼 (위젯)

  const CustomAppBar({
    super.key,
    this.isBackButton = false,
    this.title,
    this.rightWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // border: Border(
        //     bottom: BorderSide(
        //         color: Color.fromARGB(255, 165, 172, 173), width: 1)), // 테두리 선
        color: Colors.white, // 색상
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 왼쪽 영역
              Row(
                children: [
                  if (isBackButton) ...[
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      behavior: HitTestBehavior.opaque,
                      child: const Icon(
                        Icons.chevron_left,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ] else ...[
                    SvgPicture.asset(
                      'assets/svg/logo.svg',
                      height: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '다글제작소 플러터 공통 위젯',
                      style: title_M,
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (title != null)
                    Text(
                      title!,
                      style: subtitle_M,
                    ),
                ],
              ),

              // 오른쪽 영역
              rightWidget ?? const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
