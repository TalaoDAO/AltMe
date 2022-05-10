import 'package:flutter/material.dart';

class ImageFromNetwork extends StatelessWidget {
  const ImageFromNetwork(
    this.url, {
    Key? key,
    this.fit,
  }) : super(key: key);

  final String url;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) =>
          (loadingProgress == null)
              ? child
              : const Center(
                  child: CircularProgressIndicator(),
                ),
      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
    );
  }
}
