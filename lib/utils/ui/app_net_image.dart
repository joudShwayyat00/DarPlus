import 'package:cached_network_image/cached_network_image.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:flutter/material.dart';

class AppNetImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppNetImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      placeholder: (context, url) => Container(
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child:  CircularProgressIndicator(strokeWidth: 2,color: AppColors.grayBrandColor,),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey.shade300,
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image),
      ),
    );

    if (borderRadius == null) {
      return image;
    }

    return ClipRRect(
      borderRadius: borderRadius!,
      child: image,
    );
  }
}
