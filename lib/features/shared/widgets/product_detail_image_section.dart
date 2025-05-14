import 'package:flutter/material.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/core/constants/app_text_style.dart';
import 'package:myong/core/widgets/image/custom_image.dart';
import 'dart:async';

/// 상품 상세 이미지 섹션 위젯
class ProductDetailImageSection extends StatefulWidget {
  final String croppedImageUrl;
  final String detailImageUrl;

  const ProductDetailImageSection({
    required this.croppedImageUrl,
    required this.detailImageUrl,
    super.key,
  });

  @override
  State<ProductDetailImageSection> createState() =>
      _ProductDetailImageSectionState();
}

class _ProductDetailImageSectionState extends State<ProductDetailImageSection> {
  bool _isExpanded = false;
  bool _isImageLoading = false;
  double _imageHeight = 250.0; // 기본 높이

  @override
  void initState() {
    super.initState();
    _calculateImageHeight();
  }

  // 원본 이미지의 높이 계산
  Future<void> _calculateImageHeight() async {
    setState(() {
      _isImageLoading = true;
    });

    final completer = Completer<ImageInfo>();

    // 네트워크 이미지인 경우
    if (widget.detailImageUrl.startsWith('http')) {
      final image = NetworkImage(widget.detailImageUrl);
      image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((info, _) {
          completer.complete(info);
        }),
      );
    }
    // 로컬 이미지인 경우
    else {
      final image = AssetImage(widget.detailImageUrl);
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

      // 디바이스 너비에 맞는 높이 계산
      final deviceWidth = MediaQuery.of(context).size.width - 32; // 패딩 고려
      final calculatedHeight = (deviceWidth * imageHeight) / imageWidth;

      setState(() {
        _imageHeight = calculatedHeight;
        _isImageLoading = false;
      });
    } catch (e) {
      // 오류 발생 시 기본 높이 사용
      setState(() {
        _imageHeight = 250.0;
        _isImageLoading = false;
      });
      debugPrint('이미지 높이 계산 실패: $e');
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
                // 확장 상태에 따라 다른 이미지 표시
                _isExpanded
                    ? CustomImage(
                        imageUrl: widget.detailImageUrl,
                        width: contentWidth,
                        height: _imageHeight, // 계산된 높이 사용
                        fit: BoxFit.contain,
                      )
                    : CustomImage(
                        imageUrl: widget.croppedImageUrl,
                        width: contentWidth,
                        height: 250, // 크롭된 이미지용 고정 높이
                        fit: BoxFit.fitWidth,
                      ),

                // 더보기/접기 버튼
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
