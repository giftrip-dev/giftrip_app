import 'package:flutter/material.dart';
import 'package:giftrip/core/constants/app_colors.dart';
import 'package:giftrip/core/constants/app_text_style.dart';
import 'package:giftrip/core/utils/formatter.dart';
import 'package:giftrip/core/widgets/button/cta_button.dart';
import 'package:giftrip/core/widgets/image/custom_image.dart';
import 'package:giftrip/features/lodging/view_models/room_view_model.dart';
import 'package:lucide_icons/lucide_icons.dart';

class RoomItem extends StatefulWidget {
  final RoomViewModel room;
  final double width;
  final double height;
  const RoomItem({
    super.key,
    required this.room,
    required this.width,
    required this.height,
  });

  @override
  State<RoomItem> createState() => _RoomItemState();
}

class _RoomItemState extends State<RoomItem> {
  int _currentIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    if (index < 0 || index >= widget.room.imageUrls.length) return;
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.room.imageUrls;
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.lineStrong),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 슬라이더
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: SizedBox(
                    width: widget.width,
                    height: widget.height,
                    child: PageView.builder(
                      itemCount: images.length,
                      controller: _pageController,
                      onPageChanged: (idx) =>
                          setState(() => _currentIndex = idx),
                      itemBuilder: (context, idx) {
                        return CustomImage(
                          imageUrl: images[idx],
                          width: widget.width,
                          height: widget.height,
                        );
                      },
                    ),
                  ),
                ),
                // 좌우 화살표
                if (images.length > 1) ...[
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: _currentIndex > 0
                              ? () => _goTo(_currentIndex - 1)
                              : null,
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            width: 36,
                            height: 36,
                            child: Icon(
                              LucideIcons.chevronLeft,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: _currentIndex < images.length - 1
                              ? () => _goTo(_currentIndex + 1)
                              : null,
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            width: 36,
                            height: 36,
                            child: Icon(
                              LucideIcons.chevronRight,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            // 2. 제목
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                widget.room.roomName,
                style: title_L,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),
            // 3. 상세 정보
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '• 기준 ${widget.room.baseOccupancy}인 / 최대 ${widget.room.maxOccupancy}인',
                      style: caption.copyWith(
                        color: AppColors.label,
                      )),
                  const SizedBox(height: 4),
                  Text('• ${widget.room.bedType}',
                      style: caption.copyWith(color: AppColors.label)),
                  const SizedBox(height: 4),
                  Text('• ${widget.room.viewType}',
                      style: caption.copyWith(color: AppColors.label)),
                  const SizedBox(height: 4),
                  Text(
                      '• 체크인 ${widget.room.checkInTime}~체크아웃 ${widget.room.checkOutTime}',
                      style: caption.copyWith(color: AppColors.label)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // 4. 가격 및 할인율
            Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundAlternative,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.room.discountRate > 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.room.discountRate}%',
                              style: subtitle_XS.copyWith(
                                color: AppColors.labelAlternative,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${formatPrice(widget.room.originalPrice)}원',
                              style: caption.copyWith(
                                color: AppColors.labelAlternative,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ],
                      // 5. 최종 가격
                      Text(
                        '${formatPrice(widget.room.finalPrice)}원',
                        style: title_L,
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.line),
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Center(
                            child: Icon(
                              LucideIcons.shoppingCart,
                              color: AppColors.labelStrong,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 94,
                        height: 37,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: AppColors.primaryStrong,
                            disabledBackgroundColor: AppColors.componentNatural,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '예약하기',
                              style: title_S.copyWith(height: 1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
