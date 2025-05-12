import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myong/core/utils/logger.dart';
import 'package:myong/core/widgets/image/custom_image.dart';

class HomeFeatureTab extends StatelessWidget {
  const HomeFeatureTab({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'label': '체험',
        'icon': 'assets/svg/icons/experience.svg',
        'route': '/experience',
      },
      {
        'label': '쇼핑',
        'icon': 'assets/svg/icons/shopping.svg',
        'route': '/shopping',
      },
      {
        'label': '숙소',
        'icon': 'assets/svg/icons/lodging.svg',
        'route': '/lodging',
      },
      {
        'label': '체험단',
        'icon': 'assets/svg/icons/tester.svg',
        'route': '/tester',
      },
      {
        'label': '이벤트',
        'icon': 'assets/svg/icons/event.svg',
        'route': '/event',
      },
      {
        'label': '협업문의',
        'icon': 'assets/svg/icons/inquiry.svg',
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
            // CustomImage(
            //   imageUrl: f['icon']!,
            //   width: 48,
            //   height: 52,
            //   // fit: BoxFit.contain,
            // ),
            SvgPicture.asset(
              f['icon']!,
              width: 48,
              height: 52,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(
              f['label']!,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 36),
      child: Column(
        children: [
          // 첫 번째 줄
          SvgPicture.asset(
            "assets/svg/icons/event.svg",
            width: 48,
            height: 52,
            fit: BoxFit.contain,
          ),
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
