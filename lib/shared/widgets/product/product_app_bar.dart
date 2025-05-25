import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:giftrip/core/constants/item_type.dart';
import 'package:giftrip/core/utils/share_url_generator.dart';
import 'package:giftrip/core/widgets/app_bar/custom_app_bar.dart';
import 'package:giftrip/shared/widgets/cart/cart_icon_button.dart';

class ProductAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String itemId;
  final ProductItemType type;

  const ProductAppBar({
    required this.title,
    required this.itemId,
    required this.type,
    super.key,
  });

  @override
  State<ProductAppBar> createState() => _ProductAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ProductAppBarState extends State<ProductAppBar> {
  bool _isSharing = false;

  /// 공유하기 실행
  Future<void> _share() async {
    if (_isSharing) return; // 중복 클릭 방지

    setState(() {
      _isSharing = true;
    });

    try {
      final shareText = ShareUrlGenerator.generateShareMessage(
        title: widget.title,
        itemId: widget.itemId,
        type: widget.type,
      );

      await Share.share(shareText);
    } catch (e) {
      // 에러 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('공유하기에 실패했습니다.')),
      );
    } finally {
      setState(() {
        _isSharing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      isBackButton: true,
      title: widget.title,
      rightWidget: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 공유 버튼
          GestureDetector(
            onTap: _share,
            behavior: HitTestBehavior.opaque,
            child: _isSharing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                : const Icon(Icons.share_outlined,
                    size: 24, color: Colors.black),
          ),
          const SizedBox(width: 16),
          // 장바구니 버튼
          const CartIconButton(
            color: Colors.black,
            size: 24,
          ),
        ],
      ),
    );
  }
}
