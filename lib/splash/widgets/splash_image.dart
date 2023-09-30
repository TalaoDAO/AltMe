import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class SplashImage extends StatelessWidget {
  const SplashImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Transform.scale(
            scale: 1.1,
            child: SizedBox(
              child: Image.asset(
                ImageStrings.splashImage,
                fit: BoxFit.fitHeight,
                height: MediaQuery.of(context).size.longestSide / 5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
