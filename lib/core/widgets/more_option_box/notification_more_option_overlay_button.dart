import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giftrip/core/widgets/more_option_box/notification_more_option_box.dart';

class NotificationMoreOptionOverlayButton extends StatefulWidget {
  final VoidCallback onDeleteAll; // 삭제 핸들러
  final VoidCallback onReadAll; // 수정 핸들러

  final IconData icon;
  final Color iconColor;
  final double iconSize;

  const NotificationMoreOptionOverlayButton({
    Key? key,
    required this.onDeleteAll,
    required this.onReadAll,
    this.icon = LucideIcons.moreVertical,
    this.iconColor = Colors.black,
    this.iconSize = 24,
  }) : super(key: key);

  @override
  State<NotificationMoreOptionOverlayButton> createState() =>
      _NotificationMoreOptionOverlayButtonState();
}

class _NotificationMoreOptionOverlayButtonState
    extends State<NotificationMoreOptionOverlayButton> {
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
              left: position.dx + renderBox.size.width / 2 - 135,
              child: Material(
                color: Colors.transparent,
                child: NotificationMoreOptionBox(
                  targetType: "NOTIFICATION",
                  onClose: _removeOverlay,
                  onReadAll: widget.onReadAll,
                  onDeleteAll: widget.onDeleteAll,
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
