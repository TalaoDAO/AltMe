import 'package:altme/theme/theme.dart';
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
    this.errorMessage,
  }) : super(key: key);

  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    if (url.startsWith('assets')) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.asset(
          url,
          width: width,
          height: height,
        ),
      );
    } else {
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
                progressIndicatorBuilder: (context, child, downloadProgress) {
                  return errorMessage == null
                      ? Container(
                          color: Theme.of(context).colorScheme.lightGrey,
                          margin: const EdgeInsets.all(10),
                          child: Text(downloadProgress.progress.toString()),
                        )
                      : ErrorWidget(errorMessage: errorMessage);
                },
                errorWidget: (context, error, dynamic _) => errorMessage == null
                    ? Container(
                        color: Theme.of(context).colorScheme.lightGrey,
                        child: Icon(
                          Icons.error,
                          color: Theme.of(context).colorScheme.darkGrey,
                        ),
                      )
                    : ErrorWidget(errorMessage: errorMessage),
              ),
      );
    }
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    Key? key,
    required this.errorMessage,
  }) : super(key: key);

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: const [0.3, 1.0],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Text(
            errorMessage!,
            style: Theme.of(context).textTheme.cacheErrorMessage,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
