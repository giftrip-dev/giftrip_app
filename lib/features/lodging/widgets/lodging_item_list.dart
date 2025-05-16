import 'package:flutter/material.dart';
import 'package:giftrip/features/lodging/models/lodging_model.dart';
import 'package:giftrip/features/lodging/widgets/lodging_item.dart';
import 'package:giftrip/features/home/models/product_model.dart';

class LodgingItemList extends StatelessWidget {
  final List<LodgingModel> lodgings;
  final bool isLoading;
  final VoidCallback? onLoadMore;

  const LodgingItemList({
    super.key,
    required this.lodgings,
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
    const itemSpacing = 16.0;

    // 아이템 하나의 너비 및 높이 계산
    final itemWidth = screenWidth - totalPadding;
    final itemHeight = itemWidth * (213 / 328); // 328:213 비율 적용
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
                (context, index) {
                  // 남은 아이템이 없으면 null 반환
                  if (index >= lodgings.length) {
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

                  return Padding(
                    padding: EdgeInsets.only(
                      top: index > 0 ? itemSpacing : 0,
                    ),
                    child: LodgingItem(
                      lodging: lodgings[index],
                      width: itemWidth,
                      height: itemHeight,
                    ),
                  );
                },
                childCount: lodgings.length + (isLoading ? 1 : 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
