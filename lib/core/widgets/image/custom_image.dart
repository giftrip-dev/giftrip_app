import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const CustomImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  bool get _isSvg => imageUrl.toLowerCase().endsWith('.svg');
  bool get _isNetwork => imageUrl.startsWith('http');

  @override
  Widget build(BuildContext context) {
    final imageWidget = _isSvg
        ? _isNetwork
            ? SvgPicture.network(
                imageUrl,
                width: width,
                height: height,
                fit: fit,
                placeholderBuilder: (context) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
              )
            : SvgPicture.asset(
                imageUrl,
                width: width,
                height: height,
                fit: fit,
              )
        : _isNetwork
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                width: width,
                height: height,
                fit: fit,
                placeholder: (_, __) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              )
            : Image.asset(
                imageUrl,
                width: width,
                height: height,
                fit: fit,
              );

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: imageWidget,
    );
  }
}
