import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CachedImageFromNetwork extends StatelessWidget {
  const CachedImageFromNetwork(
    this.url, {
    super.key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.errorMessage,
    this.showLoading = true,
    this.bgColor,
  });

  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final String? errorMessage;
  final bool showLoading;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    if (url.startsWith('assets')) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
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
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              )
            : url.startsWith('http')
                ? CachedNetworkImage(
                    imageUrl: url,
                    fit: fit,
                    width: width,
                    height: height,
                    progressIndicatorBuilder:
                        (context, child, downloadProgress) {
                      return showLoading
                          ? DecoratedBox(
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
                            )
                          : Container(
                              color: bgColor ??
                                  Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.6),
                            );
                    },
                    errorWidget: (context, error, dynamic _) => errorMessage ==
                            null
                        ? ColoredBox(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                            child: Icon(
                              Icons.error,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          )
                        : ErrorWidget(errorMessage: errorMessage),
                  )
                : Image.memory(
                    base64Decode(url.replaceAll('data:image/jpeg;base64,', '')),
                    fit: fit,
                    width: width,
                    height: height,
                  ),
      );
    }
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    super.key,
    required this.errorMessage,
    this.bgColor,
  });

  final String? errorMessage;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bgColor,
        gradient: bgColor != null
            ? null
            : LinearGradient(
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
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
