import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class PictureDisplay extends StatelessWidget {
  const PictureDisplay({super.key, required this.credentialImage});

  final String credentialImage;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: Sizes.credentialAspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Sizes.credentialBorderRadius),
        child: CachedImageFromNetwork(
          credentialImage,
          fit: BoxFit.contain,
          width: double.infinity,
          bgColor: Colors.transparent,
          height: double.infinity,
          errorMessage: '',
          showLoading: false,
        ),
      ),
    );
  }
}
