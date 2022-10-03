import 'package:arago_wallet/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CachedImageFromNetwork extends StatelessWidget {
  const CachedImageFromNetwork(
    this.url, {
    Key? key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  }) : super(key: key);

  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: url.endsWith('.svg')
          ? SvgPicture.network(
              url,
              width: width,
              height: height,
              placeholderBuilder: (_) => Container(
                width: width,
                height: height,
                color: Theme.of(context).colorScheme.lightGrey,
              ),
            )
          : CachedNetworkImage(
              imageUrl: url,
              fit: fit,
              width: width,
              height: height,
              progressIndicatorBuilder: (context, _, loadingProgress) =>
                  Container(
                color: Theme.of(context).colorScheme.lightGrey,
              ),
              errorWidget: (context, error, dynamic _) => Container(
                color: Theme.of(context).colorScheme.lightGrey,
                child: Icon(
                  Icons.error,
                  color: Theme.of(context).colorScheme.darkGrey,
                ),
              ),
            ),
    );
  }
}
