import 'package:flutter/material.dart';
import 'package:myong/core/widgets/image/custom_image.dart';

class EventBannerWidget extends StatelessWidget {
  // todo : 실제 이미지 URL과 이동 링크를 받음
  final String? imageUrl;
  final String? linkUrl;

  const EventBannerWidget({
    super.key,
    this.imageUrl,
    this.linkUrl,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        // todo : 실제 구현 시 아래와 같이 처리
        // if (linkUrl != null) {
        //   launchUrl(Uri.parse(linkUrl!));
        // }
      },
      child: CustomImage(
        imageUrl:
            // todo : 실제 이미지 사용 시 아래를 주석 해제
            // imageUrl ?? '',

            'assets/png/banner.png',
        width: screenWidth,
        height: screenWidth,
        fit: BoxFit.cover,
      ),
    );
  }
}
