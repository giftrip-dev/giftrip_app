import 'package:flutter/material.dart';
import 'package:myong/features/experience/models/experience_model.dart';
import 'package:myong/features/experience/widgets/experience_item.dart';
import 'package:myong/features/home/models/product_model.dart';

class ExperienceItemList extends StatelessWidget {
  final List<ExperienceModel> experiences;
  final bool isLoading;
  final VoidCallback? onLoadMore;

  const ExperienceItemList({
    super.key,
    required this.experiences,
    required this.isLoading,
    this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    // 화면 너비 계산
    final screenWidth = MediaQuery.of(context).size.width;
    // 전체 패딩 (좌우 각각 16)
    const totalPadding = 32.0;
    // 아이템 사이 간격
    const itemSpacing = 12.0;
    // 그리드의 열 개수
    const columnCount = 2;

    // 아이템 하나의 너비 계산
    // (화면 너비 - 전체 패딩 - (열 개수 - 1) * 아이템 간격) / 열 개수
    final itemWidth =
        (screenWidth - totalPadding - (columnCount - 1) * itemSpacing) /
            columnCount;

    // 아이템의 높이는 이미지(정사각형) + 텍스트 영역 + 간격들의 합
    // 텍스트 영역과 간격의 예상 높이를 더해줍니다
    final itemHeight = itemWidth + 120; // 120은 이미지 아래 컨텐츠의 대략적인 높이

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 100 &&
            !isLoading &&
            onLoadMore != null) {
          onLoadMore!();
        }
        return true;
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 24,
          crossAxisSpacing: 12,
          childAspectRatio: itemWidth / itemHeight,
        ),
        itemCount: experiences.length + (isLoading ? 2 : 0),
        itemBuilder: (context, index) {
          if (index < experiences.length) {
            return ExperienceItem(
              experience: experiences[index],
              badgeType: ItemBadgeType.newArrival,
              imageSize: itemWidth,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
