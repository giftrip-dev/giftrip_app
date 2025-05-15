import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giftrip/core/widgets/more_option_box/community_more_option_box.dart';

class CommunityMoreOptionOverlayButton extends StatefulWidget {
  final bool isAuthor; // 작성자 여부
  final String authorId; // 작성자 id
  final String targetId; // 대상 id
  final String targetType; // 대상 Type ("COMMENT" | "POST")
  final VoidCallback onDelete; // 삭제 핸들러
  final VoidCallback onUpdate; // 수정 핸들러

  final IconData icon;
  final Color iconColor;
  final double iconSize;

  const CommunityMoreOptionOverlayButton({
    Key? key,
    required this.isAuthor,
    required this.authorId,
    required this.targetId,
    required this.targetType,
    required this.onDelete,
    required this.onUpdate,
    this.icon = LucideIcons.moreVertical,
    this.iconColor = Colors.black,
    this.iconSize = 24,
  }) : super(key: key);

  @override
  State<CommunityMoreOptionOverlayButton> createState() =>
      _CommunityMoreOptionOverlayButtonState();
}

class _CommunityMoreOptionOverlayButtonState
    extends State<CommunityMoreOptionOverlayButton> {
  final GlobalKey _anchorKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _anchorKey,
      onTap: _toggleOverlay,
      child: Icon(
        widget.icon,
        color: widget.iconColor,
        size: widget.iconSize,
      ),
    );
  }

  void _toggleOverlay() {
    if (_overlayEntry == null) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final renderBox =
        _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // 배경 클릭 시 오버레이가 사라지도록.
            Positioned.fill(
              child: GestureDetector(
                onTap: _removeOverlay,
                behavior: HitTestBehavior.translucent,
                child: Container(),
              ),
            ),
            // 팝오버(더보기 상자)
            Positioned(
              top: position.dy + renderBox.size.height + 8,
              left: position.dx +
                  renderBox.size.width / 2 -
                  (widget.isAuthor ? 100 : 135),
              // 원하는 위치에 맞추어 보정
              child: Material(
                color: Colors.transparent,
                child: CommunityMoreOptionBox(
                  isAuthor: widget.isAuthor,
                  authorId: widget.authorId,
                  targetId: widget.targetId,
                  targetType: widget.targetType,
                  onClose: _removeOverlay,
                  onUpdate: widget.onUpdate,
                  onDelete: widget.onDelete,
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
