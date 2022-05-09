import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class AltMeLogo extends StatelessWidget {
  const AltMeLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_altme.png',
      width: SizeHelper.logoLarge,
      height: SizeHelper.logoLarge,
      fit: BoxFit.fitHeight,
    );
  }
}
