import 'package:altme/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImageFromNetwork extends StatelessWidget {
  const CachedImageFromNetwork(
    this.url, {
    Key? key,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      progressIndicatorBuilder: (context, _, loadingProgress) => Container(
        color: Theme.of(context).colorScheme.lightGrey,
      ),
      errorWidget: (context, error, dynamic _) => Container(
        color: Theme.of(context).colorScheme.lightGrey,
        child: Icon(
          Icons.error,
          color: Theme.of(context).colorScheme.darkGrey,
        ),
      ),
    );
  }
}
