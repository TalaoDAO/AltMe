import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class SplashImage extends StatelessWidget {
  const SplashImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ImageStrings.splashImage,
      fit: BoxFit.fitWidth,
      height: MediaQuery.of(context).size.longestSide / 2.2,
    );
  }
}
