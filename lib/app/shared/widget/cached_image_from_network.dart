import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImageFromNetwork extends StatelessWidget {
  const CachedImageFromNetwork(
    this.url, {
    Key? key,
    this.fit,
  }) : super(key: key);

  final String url;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      progressIndicatorBuilder: (context, _, loadingProgress) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, error, dynamic _) => const SizedBox.shrink(),
    );
  }
}
