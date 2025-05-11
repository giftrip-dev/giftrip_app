import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  final String? imageUrl;
  final String? assetImagePath;

  const BannerWidget({
    super.key,
    this.imageUrl,
    this.assetImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: (imageUrl == null && assetImagePath == null)
            ? Theme.of(context).hoverColor
            : null,
        borderRadius: BorderRadius.circular(12),
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : assetImagePath != null
                ? DecorationImage(
                    image: AssetImage(assetImagePath!),
                    fit: BoxFit.cover,
                  )
                : null,
      ),
    );
  }
}
