import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/widgets/image/custom_image.dart';
import 'dart:async';

/// 상품 상세 이미지 섹션 위젯
class ProductDetailImageSection extends StatefulWidget {
  final String imageUrl;

  const ProductDetailImageSection({
    required this.imageUrl,
    super.key,
  });

  @override
  State<ProductDetailImageSection> createState() =>
      _ProductDetailImageSectionState();
}

class _ProductDetailImageSectionState extends State<ProductDetailImageSection> {
  bool _isExpanded = false;
  final double _collapsedHeight = 200.0;
  bool _isImageTall = false;
  bool _isImageLoading = true;

  @override
  void initState() {
    super.initState();
    _checkImageHeight();
  }

  /// 이미지 높이 체크를 위한 메서드
  Future<void> _checkImageHeight() async {
    // 이미지 로딩 중 상태로 설정
    setState(() {
      _isImageLoading = true;
    });

    final completer = Completer<ImageInfo>();

    // 네트워크 이미지인 경우
    if (widget.imageUrl.startsWith('http')) {
      final image = NetworkImage(widget.imageUrl);
      image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((info, _) {
          completer.complete(info);
        }),
      );
    }
    // 로컬 이미지인 경우
    else {
      final image = AssetImage(widget.imageUrl);
      image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((info, _) {
          completer.complete(info);
        }),
      );
    }

    try {
      final imageInfo = await completer.future;
      final imageHeight = imageInfo.image.height.toDouble();
      final imageWidth = imageInfo.image.width.toDouble();

      // 디바이스 너비를 기준으로 이미지 비율 계산
      final deviceWidth = MediaQuery.of(context).size.width - 32; // 패딩 고려
      final scaledHeight = (deviceWidth * imageHeight) / imageWidth;

      setState(() {
        _isImageTall = scaledHeight > 500;
        _isImageLoading = false;
      });
    } catch (e) {
      setState(() {
        _isImageLoading = false;
      });
      print('이미지 로딩 실패: $e');
    }
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final contentWidth = deviceWidth - 32; // 패딩 고려한 실제 컨텐츠 너비

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 제목
          Text('상품 소개', style: title_L),

          const SizedBox(height: 16),

          // 이미지 로딩 중인 경우 로딩 표시
          if (_isImageLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 100),
                child: CircularProgressIndicator(),
              ),
            )
          else
            Column(
              children: [
                // 상세 이미지 컨테이너
                ClipRect(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: _isImageTall && !_isExpanded
                          ? _collapsedHeight
                          : double.infinity,
                    ),
                    child: CustomImage(
                      imageUrl: widget.imageUrl,
                      width: contentWidth,
                      height: contentWidth, // 초기 높이 설정, 실제로는 이미지 비율에 맞게 조정됨
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),

                // 더보기/접기 버튼 - 이미지가 높을 때만 표시
                if (_isImageTall)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: GestureDetector(
                      onTap: _toggleExpand,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isExpanded ? '접기' : '더보기',
                            style: body_S.copyWith(color: AppColors.primary),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            _isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
