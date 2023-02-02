import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class SplashImage extends StatelessWidget {
  const SplashImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.space2XLarge),
      child: Image.asset(
        ImageStrings.splashImage,
        fit: BoxFit.fitWidth,
        height: MediaQuery.of(context).size.longestSide / 2.2,
      ),
    );
  }
}
