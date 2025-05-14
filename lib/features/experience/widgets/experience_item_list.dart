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
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, rowIndex) {
                  // 현재 행의 시작 인덱스
                  final startIndex = rowIndex * columnCount;
                  // 남은 아이템이 없으면 null 반환
                  if (startIndex >= experiences.length) {
                    if (isLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return null;
                  }

                  // 현재 행의 아이템들
                  final rowItems = <Widget>[];
                  for (var i = 0; i < columnCount; i++) {
                    final itemIndex = startIndex + i;
                    if (itemIndex < experiences.length) {
                      rowItems.add(
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: i > 0 ? itemSpacing : 0,
                            ),
                            child: ExperienceItem(
                              experience: experiences[itemIndex],
                              imageSize: itemWidth,
                            ),
                          ),
                        ),
                      );
                    }
                  }

                  return Padding(
                    padding: EdgeInsets.only(
                      top: rowIndex > 0 ? 24 : 0,
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: rowItems,
                      ),
                    ),
                  );
                },
                childCount: (experiences.length / columnCount).ceil() +
                    (isLoading ? 1 : 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
