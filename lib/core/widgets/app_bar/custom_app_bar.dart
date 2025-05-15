import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/widgets/image/custom_image.dart';

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
              SizedBox(
                width: 89,
                child: Row(
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
                    ] else ...[
                      CustomImage(
                          imageUrl: 'assets/png/logo.png',
                          width: 89,
                          height: 24),
                    ],
                  ],
                ),
              ),

              // 중앙 영역 (타이틀)
              if (title != null)
                Expanded(
                  child: Text(
                    title!,
                    style: subtitle_M,
                    textAlign: TextAlign.center,
                  ),
                ),

              // 오른쪽 영역
              SizedBox(
                width: 89,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: rightWidget ?? const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
