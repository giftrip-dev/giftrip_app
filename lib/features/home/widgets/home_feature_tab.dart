import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/utils/logger.dart';
import 'package:myong/core/widgets/image/custom_image.dart';

class HomeFeatureTab extends StatelessWidget {
  const HomeFeatureTab({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'label': '체험',
        'icon': 'assets/webp/icons/experience.webp',
        'route': '/experience',
      },
      {
        'label': '쇼핑',
        'icon': 'assets/webp/icons/shopping.webp',
        'route': '/shopping',
      },
      {
        'label': '숙소',
        'icon': 'assets/webp/icons/lodging.webp',
        'route': '/lodging',
      },
      {
        'label': '체험단',
        'icon': 'assets/webp/icons/tester.webp',
        'route': '/tester',
      },
      {
        'label': '이벤트',
        'icon': 'assets/webp/icons/event.webp',
        'route': '/event',
      },
      {
        'label': '협업문의',
        'icon': 'assets/webp/icons/inquiry.webp',
        'route': '/inquiry',
      },
    ];

    Widget _buildItem(Map<String, String> f) {
      logger.d(f["icon"]);
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, f['route']!);
        },
        child: Column(
          children: [
            CustomImage(
              imageUrl: f['icon']!,
              width: 48,
              height: 52,
              // fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(
              f['label']!,
              textAlign: TextAlign.center,
              style: subtitle_XS,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 36),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: features.sublist(0, 3).map(_buildItem).toList(),
          ),
          const SizedBox(height: 22),
          // 두 번째 줄
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: features.sublist(3, 6).map(_buildItem).toList(),
          ),
        ],
      ),
    );
  }
}
