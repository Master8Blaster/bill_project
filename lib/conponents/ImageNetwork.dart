import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class ImageNetwork extends StatelessWidget {
  final String? imageUrl;

  const ImageNetwork({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? "",
      fit: BoxFit.fill,
      imageBuilder: (context, imageProvider) {
        return Container(
          color: Colors.white,
          child: Image(image: imageProvider),
        );
      },
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
        child: CircularProgressIndicator(
          value: downloadProgress.progress,
          color: colorPrimary,
          strokeWidth: 2,
        ),
      ),
      errorWidget: (context, url, error) => Icon(
        Icons.image_not_supported_rounded,
        color: colorPrimary.shade100,
        size: 50,
      ),
    );
  }
}
