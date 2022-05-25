import 'package:altme/app/shared/constants/sizes.dart';
import 'package:flutter/material.dart';

class AltMeLogo extends StatelessWidget {
  const AltMeLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/image/logo_altme.png',
      width: Sizes.logoLarge,
      height: Sizes.logoLarge,
      fit: BoxFit.fitHeight,
    );
  }
}
